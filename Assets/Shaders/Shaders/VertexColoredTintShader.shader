// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

 Shader "Custom/VertexColoredTint" {
     Properties {
        _Color ( "Tint", Color) = ( 1, 1, 1, 1 )
     }
     SubShader {
         Tags {"Queue" = "Transparent" }
         Blend SrcAlpha OneMinusSrcAlpha
         Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata {
	            float4 vertex : POSITION;
	            float4 color : COLOR;
	        };

	        struct v2f {
		        float4 pos : SV_POSITION;
		        fixed4 color : COLOR;
	      	};

            v2f vert( appdata v ) {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex );
                o.color = v.color;
                return o;
            }

            half4 _Color;
            fixed4 frag( v2f i ) : SV_Target {
                return i.color * _Color;
            }

            ENDCG
         }
     } 
 }