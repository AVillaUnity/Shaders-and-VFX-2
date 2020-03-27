// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "RageSpline/Textured Worldspace" {
	Properties {
		_MainTex ("Texture (RGBA)", 2D) = "white" {}
	}

	Category {
		Tags {"RenderType"="Transparent" "Queue"="Transparent"}
		Lighting Off
        ZWrite Off
        Cull off
        Blend SrcAlpha OneMinusSrcAlpha
		BindChannels {
			Bind "Color", color
			Bind "Vertex", vertex
			Bind "Texcoord", Texcoord
		}
		
		SubShader {
			Pass {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"

                sampler2D _MainTex;
                half4 _MainTex_ST;

                struct appdata {
                    float4 vertex : POSITION;
                    fixed4 color : COLOR;
                };

                struct v2f {
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    fixed4 color : COLOR;
                };

                v2f vert (appdata v) {
                    v2f o;
                    o.pos = UnityObjectToClipPos( v.vertex );
                    o.uv = TRANSFORM_TEX( mul(unity_ObjectToWorld, v.vertex).xy, _MainTex );
                    o.color = v.color;
                    return o;
                }

                fixed4 frag( v2f i) : SV_Target {
                    return tex2D( _MainTex, i.uv ) * i.color;
                }

                ENDCG
			}
		}
	}
}
