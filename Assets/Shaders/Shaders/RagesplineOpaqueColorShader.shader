Shader "RageSpline/OpaqueColor"
{
    Properties {

    }

    Category {
        Tags {"RenderType"="Opaque" "Queue"="Geometry"}
        Lighting Off
        BindChannels {
            Bind "Color", color
            Bind "Vertex", vertex
        }
        
        SubShader {
            Pass {
                ZWrite On
                Cull Off
            }
        }
    }
}
