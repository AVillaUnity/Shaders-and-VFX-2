Shader "RageSpline/MaskeeInvert" {
	Properties {
        // Read from this stencil value on each pixel
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
	                Comp NotEqual
	                Pass Zero
	            }

				ZWrite Off
				Cull Off
				Blend SrcAlpha OneMinusSrcAlpha
			}
		}
	}
}

