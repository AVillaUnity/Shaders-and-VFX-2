Shader "Depth Mask" {
    SubShader {
        Tags {"Queue" = "Geometry" }       
        Lighting Off
        ZTest LEqual
        ZWrite On
        ColorMask 0
        Pass {}
    }
}