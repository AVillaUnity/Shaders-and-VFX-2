Shader "Alvaro/Striped"
{
	Properties
	{
		_Color1("Stripe 1", Color) = (1,1,1,1)
		_Color2("Stripe 2", Color) = (1,1,1,1)
		_StripeSize("Stripe Size", Range(0, 10)) = 1
        _MainTex ("Texture", 2D) = "white" {}
		_RimStrength ("Rim Strength", Range(1, 20)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
		fixed4 _Color1;
		fixed4 _Color2;
		half _StripeSize;
		half _RimStrength;

        struct Input
        {
            float2 uv_MainTex;
			float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			float rim = pow(1 - dot(IN.worldPos, o.Normal), _RimStrength);
			o.Emission = ((frac(IN.worldPos.y * 10 * 0.5 * _StripeSize) > 0.4 ? _Color1 : _Color2) * rim).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
