Shader "Alvaro/MyShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
		_Intensity("Intensity", Range(0,5)) = 1
		_Texture("Texture", 2D) = "white" {}
    }
    SubShader
    {
        CGPROGRAM
			#pragma surface surf Lambert

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			struct Input
			{
				float2 uv_MainTex;
			};

			fixed4 _Color;
			half _Intensity;
			sampler2D _Texture;

			void surf (Input IN, inout SurfaceOutput o)
			{
				o.Albedo = (tex2D(_Texture, IN.uv_MainTex) * _Color * _Intensity).rgb;
			}
        ENDCG
    }
    FallBack "Diffuse"
}
