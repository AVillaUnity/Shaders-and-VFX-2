// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/GradientWave"
{
	Properties
	{
        _TopColor ("Top Color", Color) = (1, 1, 1, 1)
        _BottomColor ("Bottom Color", Color) = (1, 1, 1, 1)

        _Amplitude ("Amplitude", Float) = 0.25
        _Frequency ("Frequency", Float) = 1
        _Speed ("Speed", Float) = 1

        _Amplitude2 ("Amplitude (Superimposed)", Float) = 0.25
        _Frequency2 ("Frequency (Superimposed)", Float) = 1
        _Speed2 ("Speed (Superimposed)", Float) = 1

        _GradientOffset ("Gradient Offset", Float) = 0
        _GradientScale ("Gradient Scale", Float) = 1
	}

	SubShader
	{
		Tags { "Queue"="Transparent" }
		LOD 100
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #include "UnityCG.cginc"

			struct appdata
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
                float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			v2f vert (appdata input)
			{
				v2f output;
				output.pos = UnityObjectToClipPos(input.pos);
				output.uv = input.uv;
				return output;
			}

            fixed4 _TopColor, _BottomColor;
            float _Amplitude, _Frequency, _Speed, _Amplitude2, _Frequency2, _Speed2;
            float _GradientOffset, _GradientScale;

			fixed4 frag(v2f input) : SV_Target
			{
                half bottom = _Amplitude * sin(_Frequency * input.uv.x + _Speed * _Time.y) +
                              _Amplitude2 * cos(_Frequency2 * input.uv.x + _Speed2 * _Time.y);
                bottom += _Amplitude + _Amplitude2; // normalize

                if (input.uv.y < bottom)
                    return fixed4(0, 0, 0, 0);

                input.uv.y = (input.uv.y - bottom) / (1 - bottom);

				return lerp(_BottomColor, _TopColor, _GradientScale * input.uv.y + _GradientOffset);
			}
			ENDCG
		}
	}
}
