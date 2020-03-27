Shader "Custom/UI/TextNoStencil" {
    Properties {
        _MainTex ("Font Texture", 2D) = "white" {}
        _Color ("Text Color", Color) = (1,1,1,1)

        _ColorMask ("Color Mask", Float) = 15
    }

    Fallback "Custom/UI/NoStencil"
}