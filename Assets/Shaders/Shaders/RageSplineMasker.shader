Shader "RageSpline/Masker" {
	Properties {
        // Write to this stencil value on each pixel
        _StencilRef ("Stencil Ref", Float) = 100
	}

	Category {
		Tags {"RenderType"="Transparent" "Queue"="Transparent"}
		Lighting Off
		BindChannels {
			Bind "Color", color
			Bind "Vertex", vertex
		}
		
		SubShader {
			Pass {
				Stencil {
	                Ref [_StencilRef]
	                Comp always
	                Pass replace
	            }

				ZWrite Off
				Cull Off
				Blend SrcAlpha OneMinusSrcAlpha
			}
		}
	}
}

