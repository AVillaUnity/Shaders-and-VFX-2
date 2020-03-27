// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SpriteMasker" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_StencilLayer("StencilLayer", int) = 5
	}
	SubShader {
		Tags {"Queue" = "Transparent" }
		Stencil {
		// write 5 to stencil on each pixel
            Ref [_StencilLayer]
            Comp always
            Pass replace
        }
        Pass {
        	ZTest On
        	ZWrite On
			Cull Back
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float depth : TEXCOORD1;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.depth = o.vertex.z/o.vertex.w;
				return o;
			}
			
			float4 _Color;
			void frag (v2f i, out half4 color:SV_Target	)
			{
				float4 col = _Color * tex2D(_MainTex, i.texcoord) * i.color;
				color = col;
				
			}
		ENDCG
        }
    }
	FallBack "Diffuse"
}
