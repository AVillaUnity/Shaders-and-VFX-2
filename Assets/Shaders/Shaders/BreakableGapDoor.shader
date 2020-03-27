Shader "Custom/BreakableGapDoor" {
	Properties {
		_Color ("Color", Color) = (.5,.5,1,1)
		_StencilLayer("StencilLayer", int) = 5
	}

	Category {
		Tags {"RenderType"="Transparent" "Queue"="Transparent"}
		Lighting Off
		ColorMask RGB
		SubShader {
			Pass {
				Stencil {				   
	                Ref [_StencilLayer]
	                Comp always
	                Pass replace
	            }
            	Color [_Color]
				ZWrite Off
				Cull Off
				Blend SrcAlpha OneMinusSrcAlpha
			}
		}
	}
}

