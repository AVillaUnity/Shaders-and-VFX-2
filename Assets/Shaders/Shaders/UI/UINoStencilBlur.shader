// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/UI/NoStencilBlur" {
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
                half2 texcoord  : TEXCOORD0;
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
            float4 _MainTex_TexelSize;
            half4 _BlurDirection;

            fixed4 frag(v2f IN) : SV_Target
            {
		        fixed4 computedColor = tex2D(_MainTex, IN.texcoord) * 0.3;

		        computedColor += tex2D(_MainTex, IN.texcoord + 5 * _BlurDirection.xy ) * .025;
		        computedColor += tex2D(_MainTex, IN.texcoord - 5 * _BlurDirection.xy ) * .025;

		        computedColor += tex2D(_MainTex, IN.texcoord + 4 * _BlurDirection.xy ) * .05;
		        computedColor += tex2D(_MainTex, IN.texcoord - 4 * _BlurDirection.xy ) * .05;		          

		        computedColor += tex2D(_MainTex, IN.texcoord + 3 * _BlurDirection.xy ) * .09;
		        computedColor += tex2D(_MainTex, IN.texcoord - 3 * _BlurDirection.xy ) * .09;
		   
		        computedColor += tex2D(_MainTex, IN.texcoord + 2 * _BlurDirection.xy ) * .12;
		        computedColor += tex2D(_MainTex, IN.texcoord - 2 * _BlurDirection.xy ) * .12;

		        computedColor += tex2D(_MainTex, IN.texcoord + _BlurDirection.xy ) * .15;
		        computedColor += tex2D(_MainTex, IN.texcoord - _BlurDirection.xy ) * .15;

		        computedColor += tex2D(_MainTex, IN.texcoord + .5 * _BlurDirection.xy ) * .35;
		        computedColor += tex2D(_MainTex, IN.texcoord - .5 * _BlurDirection.xy ) * .35;

		        computedColor *= ( 0.535 );

		        return computedColor * IN.color;
            }
        ENDCG
        }
    }
}