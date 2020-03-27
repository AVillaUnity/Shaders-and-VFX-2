Shader "Alvaro/GreenChannel"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
		fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
			fixed4 newTexture = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			newTexture.g = 1;
			o.Albedo = newTexture;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
