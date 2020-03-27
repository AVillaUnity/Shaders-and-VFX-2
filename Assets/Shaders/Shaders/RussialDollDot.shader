// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

 Shader "Custom/RussianDoll" {
     Properties {

    _MainTex ("Base (RGB)", 2D) = "white" {}
    _MaskTex ("Mask (RGB)", 2D) = "white" {}

	_Color1 ("Color1", Color) = (1,1,1,1)
	_Color2 ("Color2", Color) = (1,1,1,1)
	_Color3 ("Color3", Color) = (1,1,1,1)

	_Alpha ("Alpha", Range(0,1)) = 1

     }
     SubShader {
        Tags {"Queue" = "Transparent" }
        Pass {
        	ZTest On
        	ZWrite On
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordMask : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _MaskTex;
			float4 _MaskTex_ST;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.texcoordMask = TRANSFORM_TEX(v.texcoord, _MaskTex);
				return o;
			}
			
			float4 _Color1;
			float4 _Color2;
			float4 _Color3;
			half _Alpha;

			void frag (v2f i, out half4 color:SV_Target	)
			{
			    float alpha;
			    alpha = frac( i.texcoord.x - i.texcoord.y );
                     
			    float maskAlpha = tex2D(_MaskTex, i.texcoordMask).a;

			    if (alpha < .333) {
				color = _Color1;
				} else if (alpha < .6666) {
				color = _Color2;
				} else {
				color = _Color3;
				}
				color.a = maskAlpha * _Alpha;
			}
		ENDCG
        }
     } 
 }