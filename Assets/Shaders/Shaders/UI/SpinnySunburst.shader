// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/UI/SpinnySunburst" {
    Properties
    {
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _ForegroundColor ("Foreground Color", Color) = (0.5,0.5,0.5,1)
        _BackgroundColor ("Background Color", Color) = (1,1,1,1)
        _RayCount ("Ray Count", Int) = 24
        _RayAngleAmp ("Ray Angle Variation", Float) = 1
        _RPS ("Rotations per Second", Float) = 1
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _Origin ("Origin", Vector) = (0,0,0,0)
    }

    SubShader
    {
        Tags
        { 
            "Queue"="Transparent" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent" 
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Fog { Mode Off }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityUI.cginc"
            
            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex          : SV_POSITION;
                fixed4 foregroundColor : COLOR0;
                float4 backgroundColor : COLOR1;
                half2 texcoord         : TEXCOORD0;
                float4 worldPosition   : TEXCOORD2;
            };

            static const float TWO_PI = 2 * 3.14;

            fixed4 _ForegroundColor;
            fixed4 _BackgroundColor;
            float4 _RampTex_ST;
            float4 _Origin;
            float4 _ClipRect;

            float _RayCount;
            float _RayAngleAmp;
            float _RPS;

            sampler2D _RampTex;

            bool _UseClipRect;


            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.worldPosition = IN.vertex;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);

                // shift UV coords so that origin is at Origin
                OUT.texcoord = (IN.texcoord - _Origin.xy)*2-1;

#ifdef UNITY_HALF_TEXEL_OFFSET
                OUT.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
#endif
                ///- I can't forsee any visual need to multiply all 4 components by the component color.
                ///- Only alpha is useful for fade in-out animations. 
                ///- Swizzle away.
                OUT.foregroundColor  = half4(_ForegroundColor.xyz, IN.color.a * _ForegroundColor.a);
                OUT.backgroundColor  = half4(_BackgroundColor.xyz, IN.color.a * _BackgroundColor.a);

                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                // concept: use Polar coordinate (radius (r), rotation angle (phi)) for ramp lookups.
                // find phi and change over time (rotation animation)
                float rot = _Time.y * _RPS * TWO_PI + TWO_PI;
                float phi = atan2(IN.texcoord.y, IN.texcoord.x) + rot;

                // Lookup radial alpha from ramp for foregroundColor, backgroundColor at radius = length(IN.texcoord)
                fixed3 ramp = tex2D(_RampTex, TRANSFORM_TEX(float2(0, length(IN.texcoord)), _RampTex)).rgb;
                // 3-component (channel) vector from ramp is used as follows:
                IN.foregroundColor.a *= ramp.g; /// foregroundColor radial alpha ramp is stored in the Green channel
                IN.backgroundColor.a *= ramp.b; /// backgroundColor radial alpha ramp is stored in the Blue channel
                /// composite ramp for foreground onto background is in the red channel
                IN.foregroundColor = lerp(IN.backgroundColor, IN.foregroundColor, ramp.r);

                // find ray index (integer between 0 and _RayCount), using skewed phi to randomize ray angle
                float rayAngle  = TWO_PI / _RayCount;
                float phiSkewed = phi + _RayAngleAmp * rayAngle * sin(phi) * rayAngle * cos(4 * phi);

                // ray index: floor(phiSkewed / rayAngle)
                // odd rays have foreground color
                // note: floor and fmod may be unsupported in fp20
                half4 finalColor = fmod(floor(phiSkewed / rayAngle), 2) == 0 ? IN.foregroundColor : IN.backgroundColor;

                if (_UseClipRect)
                    finalColor *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                
                return finalColor;
            }
        ENDCG
        }
    }
}
