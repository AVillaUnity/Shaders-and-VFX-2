Shader "Alvaro/Properties"
{
    Properties
    {
		_Normal("Normal", 2D) = "bump" {}
		_CubeMap("Cube Map", CUBE) = "" {}
	}
		SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _Normal;
		samplerCUBE _CubeMap;


        struct Input
        {
			float2 uv_Normal;
			float3 worldRefl; INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            o.Albedo = texCUBE(_CubeMap, WorldReflectionVector(IN, o.Normal)).rgb;
			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal)) * 0.3;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
