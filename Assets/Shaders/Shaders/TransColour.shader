// Same as colour but with alpha blend
Shader "Unlit/TransparentColour" 
{
    Properties 
    {
        _Color ("Main Colour, Alpha", Color) = ( 1, 1, 1, 0.5 )
    }
    Category 
    {
        ZWrite Off
        Lighting Off
        Tags {Queue=Transparent}
        Blend SrcAlpha OneMinusSrcAlpha
        Color [_Color]
        
        SubShader 
        {
            Pass 
            {
                Cull Off
            }
        }
    } 
}
