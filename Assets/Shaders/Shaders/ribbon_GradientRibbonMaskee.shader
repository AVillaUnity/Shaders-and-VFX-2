// NOTE: This shader is fragile because it renders a transparent object that
// is meant to occlude itself. It will not work properly unless the the vertices 
// of the mesh are ordered (and thus drawn) front to back.

Shader "Unlit/GradientRibbonMaskee"
{
	Properties
	{
		_TopColor ("Top Color", Color) = (1, 1, 1, 1)
        _BottomColor ("Bottom Color", Color) = (1, 1, 1, 1)
        _BackColor ("Back Color", Color) = (1, 1, 1, 1)
        _RampTex ("Ramp Texture", 2D) = "white" {}

        _AmplitudeX ("Amplitude X", float) = 1
        _FrequencyX ("Frequency X", float) = 1
        _SpeedX ("Speed X", float) = 1

        _AmplitudeS ("Amplitude (Superimposed)", float) = 1
        _FrequencyS ("Frequency (Superimposed)", float) = 1
        _SpeedS ("Speed (Superimposed)", float) = 1

        _FrequencyM ("Frequency (Modulation)", float) = 1
        _SpeedM ("Speed (Modulation)", float) = 1

        _AmplitudeY ("Amplitude Y", float) = 1
        _FrequencyY ("Frequency Y", float) = 1
        _SpeedY ("Speed Y", float) = 1
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }

        Stencil {
            Ref 5
            Comp Equal
            Pass Keep
        }

        // Manipulate geometry and color front of plane
		Pass
		{      
            Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #include "UnityCG.cginc"
//            #include "RibbonWaveCG.cginc"

			struct appdata
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
                float4 pos : SV_POSITION;
                fixed4 color : TEXCOORD0;
			};

            sampler2D _RampTex;
            float4 _RampTex_ST;
            fixed4 _TopColor, _BottomColor;

            float _AmplitudeX, _FrequencyX, _SpeedX;
            float _AmplitudeY, _FrequencyY, _SpeedY;
            float _AmplitudeS, _FrequencyS, _SpeedS;
            float _FrequencyM, _SpeedM;

            float4 wavePosWorld(float4 worldPos, float2 uv) 
            {
                float superimposedOffset = _AmplitudeS * cos(_FrequencyS * uv.x + _SpeedS * _Time.y);
                float modulation = 0.5 * sin(_FrequencyM * uv.x + _SpeedM * _Time.y);
                float x = worldPos.x + modulation * _AmplitudeX * sin(_FrequencyX * uv.x + _SpeedX * _Time.y) + superimposedOffset;
                float y = worldPos.y + _AmplitudeY * sin(_AmplitudeY * uv.x + _SpeedY * _Time.y);
                return float4(x, y, worldPos.zw);
            }
			
			v2f vert(appdata input)
			{
				v2f output;

                float4 worldPos = mul(unity_ObjectToWorld, input.pos);
				output.pos = mul(UNITY_MATRIX_VP, wavePosWorld(worldPos, input.uv));

                float2 adjUV = TRANSFORM_TEX(input.uv, _RampTex);
                output.color = lerp(_BottomColor, _TopColor, tex2Dlod(_RampTex, float4(adjUV, 0, 0)).a);

				return output;
			}
			
			fixed4 frag(v2f input) : SV_Target
			{
				return input.color;
			}
			ENDCG
		}

        // Manipulate geometry (again) and color back of plane        
        Pass
        {
            Cull Front

            Stencil {
                Ref 5
                Comp Equal
                Pass Zero
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
//            #include "RibbonWaveCG.cginc"

            struct appdata
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed4 color : TEXCOORD0;
            };

            sampler2D _RampTex;
            float4 _RampTex_ST;
            fixed4 _BackColor;

            float _AmplitudeX, _FrequencyX, _SpeedX;
            float _AmplitudeY, _FrequencyY, _SpeedY;
            float _AmplitudeS, _FrequencyS, _SpeedS;
            float _FrequencyM, _SpeedM;

            float4 wavePosWorld(float4 worldPos, float2 uv) 
            {
                float superimposedOffset = _AmplitudeS * cos(_FrequencyS * uv.x + _SpeedS * _Time.y);
                float modulation = 0.5 * sin(_FrequencyM * uv.x + _SpeedM * _Time.y);
                float x = worldPos.x + modulation * _AmplitudeX * sin(_FrequencyX * uv.x + _SpeedX * _Time.y) + superimposedOffset;
                float y = worldPos.y + _AmplitudeY * sin(_AmplitudeY * uv.x + _SpeedY * _Time.y);
                return float4(x, y, worldPos.zw);
            }

            v2f vert(appdata input)
            {
                v2f output;

                float4 worldPos = mul(unity_ObjectToWorld, input.pos);
                output.pos = mul(UNITY_MATRIX_VP, wavePosWorld(worldPos, input.uv));

                float2 adjUV = TRANSFORM_TEX(float2(1, 1) - input.uv, _RampTex);
                output.color = fixed4(_BackColor.xyz, tex2Dlod(_RampTex, float4(adjUV, 0, 0)).a);

                return output;
            }
            
            fixed4 frag(v2f input) : SV_Target
            {
                return input.color;
            }
            ENDCG
        }
	}
}
