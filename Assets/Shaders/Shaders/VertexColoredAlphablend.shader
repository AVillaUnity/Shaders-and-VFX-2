 Shader "Custom/VertexColored Alphablend" {
     Properties {
     }
     SubShader {
        Tags { "Queue" = "Transparent" }
         Pass {
            Blend SrcAlpha OneMinusSrcAlpha
             ColorMaterial AmbientAndDiffuse
         }
     } 
 }