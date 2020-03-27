Shader "Custom/UI/RingSmoothed" 
{
	Properties 
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Thickness("Thickness", Float) = 50
		_Radius("Radius", Range(0.0, 1)) = 0.4
		_Smoothing("Smoothing", Range(0.01, 4)) = 0.1

		[Header(UI Stencil Properties)]
		_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255
		_ColorMask("Color Mask", Float) = 15
	}
 
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}
 
		Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}

		ColorMask[_ColorMask]

		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		Blend SrcAlpha One

		Pass 
		{
			Blend SrcAlpha OneMinusSrcAlpha // Alpha blending
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile DUMMY PIXELSNAP_ON
				
			float _Thickness;
			float _Radius;
			float _Smoothing;

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color : COLOR;
				half2 uv  : TEXCOORD0;
			};

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.uv = IN.uv.xy - fixed2(0.5,0.5);
				OUT.color = IN.color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap(OUT.vertex);
				#endif

				return OUT;
			}

			// smoothing = percentage of thickess to smooth
			float SmoothedAlpha(float radius, float distance, float thickness, float smoothing) 
			{
				float innerEdge = radius - thickness;
				float outerEdge = radius; 

				if(distance < innerEdge)
				{
					return -pow(distance - innerEdge, 2) / pow(smoothing * thickness, 2) + 1.0;
				}
				else if (distance > outerEdge)
				{
					return -pow(distance - outerEdge, 2) / pow(smoothing * thickness, 2) + 1.0; 
				}
				else
				{
					return 1.0;
				}
			}

			fixed4 frag(v2f i) : SV_Target 
			{
				float distance = sqrt(pow(i.uv.x, 2) + pow(i.uv.y,2));
				float smoothing = SmoothedAlpha(_Radius, distance, _Thickness * .001f, _Smoothing);

				fixed4 color = i.color;
				color.a = smoothing * i.color.a;
				clip(color.a - .01);
				return color;
			}
			ENDCG
		}
	}
}
