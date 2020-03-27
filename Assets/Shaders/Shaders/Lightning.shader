// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Lightning" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		_Cutoff( "Cutoff", Range( 0, 1 ) ) = 0.5
	}
	SubShader {
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
        Pass {
        	ZWrite Off
			Cull Off
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature ETC1_EXTERNAL_ALPHA

			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 alphatexcoord : TEXCOORD1;
			};

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			float4 _AlphaTex_ST;
			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX( v.texcoord, _MainTex );
				o.alphatexcoord = TRANSFORM_TEX( v.texcoord, _AlphaTex );
				return o;
			}
			
			float4 _Color;
			float _Cutoff;
			void frag (v2f i, out half4 color:SV_Target	)
			{
				color = _Color * tex2D(_MainTex, i.texcoord) * i.color;
				float colAlpha = color.a * tex2D(_AlphaTex, i.alphatexcoord).a;

				color.a = saturate((colAlpha - _Cutoff )/ 0.05f );
				
			}
		ENDCG
        }
    }
	FallBack "Diffuse"
}
