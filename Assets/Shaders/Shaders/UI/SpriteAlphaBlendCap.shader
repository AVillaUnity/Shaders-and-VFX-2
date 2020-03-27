// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// used this as reference for this shader: https://mispy.me/unity-alpha-blending-overlap/

/// <summary>
/// Apply this shader to multiple 2D sprites with transparencies if you don't want the transparency values to add and instead cap
/// at a specific value. 
/// </summary>
Shader "Custom/SpriteAlphaBlendCap"
{
    Properties {
	     _MainTex("Sprite", 2D) = "white" {}
	     _Color("Color", Color) = (0,0,0,0)
	     _TargetAlpha("Alpha to lock at", Float) = 0.15
	     [IntRange] _StencilRef ("Stencil Reference Value", Range(0,255)) = 2
	 }
    SubShader {
	    Tags
        {
            "Queue" = "Transparent+1"
        }

		Pass {
		    Stencil {
		        Ref [_StencilRef]
		        Comp NotEqual
		        Pass Replace
		    }

		     Blend SrcAlpha OneMinusSrcAlpha     
	 
			 CGPROGRAM
			 #pragma vertex vert
			 #pragma fragment frag
			 #include "UnityCG.cginc"
			 
			 uniform sampler2D _MainTex;
			 float4 _Color;
			 Float _TargetAlpha;
			 			 
            struct Vertex
            {
                float4 vertex : POSITION;
                float2 uv_MainTex : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };
            
            struct v2f
            {
                float4 vertex : POSITION;
                float2 uv_MainTex : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };

            v2f vert(Vertex v)
            {
                v2f o;
    
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv_MainTex = v.uv_MainTex;
                o.uv2 = v.uv2;
    
                return o;
            }

			 half4 frag (v2f IN) : COLOR {
			     half4 color = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			     
			    if (color.a >= _TargetAlpha)
                {
                    color.a = _TargetAlpha;
                    return color;
                }
			     
			    return color;
			 }
			 ENDCG
		}

	}
 
	Fallback off
}
