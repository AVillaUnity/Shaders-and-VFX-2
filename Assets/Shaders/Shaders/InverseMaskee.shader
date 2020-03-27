Shader "InverseMaskee" {
	Properties {
		_Color ("Color", Color) = (.5,.5,1,1)
	}

	Category {
		Tags {"RenderType"="Transparent" "Queue"="Transparent"}
		Lighting Off
		
		SubShader {
			Pass {
				Stencil {
				//  Render yourself as long as you aren't overlapping with a 5 in stencil buffer
	                Ref 5
	                Comp NotEqual
	                Pass Keep
	            }
	            Color [_Color]
	            ZWrite Off
				Cull Off
				Blend SrcAlpha OneMinusSrcAlpha
			}
		}
	}
}