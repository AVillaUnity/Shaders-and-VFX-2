// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/NorthernLightsSimple"
{
	Properties
	{
        _TopColor ("Top Color", Color) = (1, 1, 1, 1)
        _BottomColor("Bottom Color", Color) = (1, 1, 1, 0)

        _Amplitude ("Amplitude", Float) = 0.1
        _Frequency ("Frequency", Float) = 1
        _Speed ("Speed", Float) = 1

        _AmplitudeTop ("Amplitude Top", Float) = 0.1
        _FrequencyTop ("Frequency Top", Float) = 1
        _SpeedTop ("Speed Top", Float) = 1

        _Amplitude2 ("Amplitude (Superimposed)", Float) = 0.1
        _Frequency2 ("Frequency (Superimposed)", Float) = 1
        _Speed2 ("Speed (Superimposed)", Float) = 1
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
            float _AmplitudeTop, _FrequencyTop, _SpeedTop;

			fixed4 frag(v2f input) : SV_Target
			{
                float super = _Amplitude2 * cos(_Frequency2 * input.uv.x + _Speed2 * _Time.y);
                float ampOffset = _Amplitude + _Amplitude2;

                half bottom = _Amplitude * sin(_Frequency * input.uv.x + _Speed * _Time.y) + super;
                bottom += ampOffset; // normalize

                if (input.uv.y < bottom)
                    return fixed4(0, 0, 0, 0);

                half top = 1 - _AmplitudeTop * sin(_FrequencyTop * input.uv.x + _SpeedTop * _Time.y) + super;
                top -= ampOffset; // normalize

                input.uv.y = (input.uv.y - bottom) / (top - bottom);

                return lerp(_BottomColor, _TopColor, input.uv.y);
			}
			ENDCG
		}
	}
}
