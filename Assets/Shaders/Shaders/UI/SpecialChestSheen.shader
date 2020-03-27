// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

///- this shader renders an animated sheen swipe in one pass given 'sprite' and sheen textures 
Shader "Custom/UI/SpecialChestSheen" {
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _SheenTex ("Sprite Texture", 2D) = "white" {}
        _SheenThinness ("Sheen Thinness", Float) = 1
        _SheenRotation ("Sheen Rotation", Float) = 0
        _SheenOffset ("Sheen Offset", Float) = 0
        _SheenMax ("Sheen Max", Float) = 1
        _SheenMin ("Sheen Min", Float) = 0
        _SheenTime ("Sheen Time", Float) = 6
        _SheenSpeed ("Sheen Speed", Float) = 2
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
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                half2 texcoord  : TEXCOORD0;
                half2 uvSheen   : TEXCOORD2;
                float4 worldPosition : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _SheenTex;
            fixed _SheenThinness;
            fixed _SheenRotation;
            fixed _SheenOffset;
            fixed _SheenMax;
            fixed _SheenMin;
            fixed _SheenTime;
            fixed _SheenSpeed;

            ///- magical unity vars
            float4 _ClipRect;
            bool _UseClipRect;

            ///- this mod function is optimized in that it does not preserve sign
            fixed md(fixed a, fixed b)
            {
                return frac(abs(a/b))*abs(b);
            }

            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.worldPosition = IN.vertex;
                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.texcoord = IN.texcoord;
#ifdef UNITY_HALF_TEXEL_OFFSET
                OUT.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
#endif
                ///- vertex-side rotation
                float cs = cos(_SheenRotation);
                float sn = sin(_SheenRotation);
                ///- vertex-side UV scrolling (animate offset)
                _SheenOffset += md(_Time.y, _SheenTime) * _SheenSpeed;
                ///- apply offset and rotation
                float y  = _SheenOffset+IN.texcoord.y;
                OUT.uvSheen.x = IN.texcoord.x * cs - y * sn; 
                OUT.uvSheen.y = IN.texcoord.x * sn + y * cs;
                ///- apply thinness
                OUT.uvSheen.y *= _SheenThinness;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                ///- sample texture data
                half4 spriteTex =  tex2D(_MainTex,  IN.texcoord);
                half4 sheenTex  =  tex2D(_SheenTex, IN.uvSheen);
                ///- Relative Luminance: http://bit.ly/2aqEsrY
                fixed sum = spriteTex.r*0.2126 + spriteTex.g*0.7152 + spriteTex.b*0.0722;
                ///- max/min is relative, as they are boundless and/or signed
                sum = (sum - _SheenMin) / (_SheenMax-_SheenMin);
                ///- additive blending with multiplied alpha scaled by sum
                spriteTex.rgb += sheenTex.rgb * sheenTex.a * spriteTex.a * sum;
                ///- unity magical stuff that must fake-discard (zero alpha) clipped frags
                if (_UseClipRect)
                    spriteTex *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                ///- return the final frag color
                return spriteTex;
            }
        ENDCG
        }
    }
}