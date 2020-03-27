// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/UI/Linear Tint/NoStencilBlur" {
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _BlurDirection ( "BLur Direction", Vector ) = (1, 0, 0, 0)

        _ColorMask ("Color Mask", Float) = 15
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

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Fog { Mode Off }
        Blend SrcAlpha OneMinusSrcAlpha
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
                fixed2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
            };
            
            fixed4 _Color;
			fixed4 _TextureSampleAdd;
	
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
            fixed4 _MainTex_TexelSize;
            fixed4 _BlurDirection;

            fixed4 blurTex( half2 uv ) {
            	if ( uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1 )
            		return fixed4(0, 0, 0, 0);
            	
            	return tex2D( _MainTex, uv );	
            }

            fixed4 frag(v2f IN) : SV_Target
            {
            	fixed2 adjustedBlur = _BlurDirection.xy * _MainTex_TexelSize.zw * 0.01;
		        fixed4 computedColor = blurTex( IN.texcoord);
		        fixed texAlpha = computedColor.a;

		        computedColor += blurTex( IN.texcoord + 4 * adjustedBlur );
		        computedColor += blurTex( IN.texcoord - 4 * adjustedBlur );		          

		        computedColor += blurTex( IN.texcoord + 3 * adjustedBlur );
		        computedColor += blurTex( IN.texcoord - 3 * adjustedBlur );
		   
		        computedColor += blurTex( IN.texcoord + 2 * adjustedBlur );
		        computedColor += blurTex( IN.texcoord - 2 * adjustedBlur );

		        computedColor += blurTex( IN.texcoord + adjustedBlur );
		        computedColor += blurTex( IN.texcoord - adjustedBlur );

		        computedColor *= ( 0.1 );

		        computedColor.rgb = lerp( computedColor.rgb, IN.color.rgb, IN.color.a );
		        computedColor.a = max( computedColor.a, texAlpha );

				if (_UseClipRect)
					computedColor *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);

		        return computedColor;
            }
        ENDCG
        }
    }
}