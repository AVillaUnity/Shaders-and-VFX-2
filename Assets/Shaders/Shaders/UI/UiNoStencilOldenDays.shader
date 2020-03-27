// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/UI/Stencil Olden Days" {
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        _Saturation ( "Saturation", Range( 0, 1 ) ) = .2
        _Contrast ( "Contrast", Range( 0, 1 ) ) = .5
        _Sepia ( "Sepia Color", Color ) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags
        { 
            "Queue"="Transparent" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent" 
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Fog { Mode Off }
        Blend DstColor Zero
        ColorMask [_ColorMask]

        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
			#include "UnityUI.cginc"
            
            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
            };
            
            fixed4 _Color;
	
			bool _UseClipRect;
			float4 _ClipRect;

            v2f vert(appdata_t IN)
            {
                v2f OUT;
				OUT.worldPosition = IN.vertex;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.texcoord = IN.texcoord;
#ifdef UNITY_HALF_TEXEL_OFFSET
                OUT.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
#endif
                OUT.color = IN.color * _Color;
                return OUT;
            }

            sampler2D _MainTex;
            uniform half _Saturation, _Contrast;
            uniform half4 _Sepia;

            fixed4 frag(v2f IN) : SV_Target
            {
            	half4 tex =  tex2D(_MainTex, IN.texcoord);
            	half3 greyscale = Luminance( tex.rgb ) + _Sepia;

            	// desaturation & sepia
			    tex.rgb = lerp( greyscale.rgb, tex.rgb, _Saturation );

			    // saturation
			    tex.rgb = (tex.rgb - .5) * ( _Contrast * 2 ) + .5;

                return lerp( half4(1,1,1,1), tex, UnityGet2DClipping(IN.worldPosition.xy, _ClipRect) );
            }
        ENDCG
        }
    }
}