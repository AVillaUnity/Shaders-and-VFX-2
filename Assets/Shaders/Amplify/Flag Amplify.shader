// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Alvaro/Flag Amplify"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Frequency("Frequency", Range( 0 , 10)) = 0
		_Speed("Speed", Range( 1 , 10)) = 0
		_Amplitude("Amplitude", Range( 0 , 10)) = 0
		_StaticLength("Static Length", Range( 0 , 10)) = 1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Frequency;
		uniform float _Speed;
		uniform float _StaticLength;
		uniform float _Amplitude;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 appendResult21 = (float4(ase_vertex3Pos.x , ase_vertex3Pos.y , ( ase_vertex3Pos.z + ( ( sin( ( ( ase_vertex3Pos.x * _Frequency ) + ( _Time.y * _Speed ) ) ) * pow( ( 1.0 - v.texcoord.xy.x ) , _StaticLength ) ) * _Amplitude ) ) , 0.0));
			v.vertex.xyz = appendResult21.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float4 tex2DNode22 = tex2D( _TextureSample1, uv_TextureSample1 );
			o.Albedo = tex2DNode22.rgb;
			o.Emission = tex2DNode22.rgb;
			o.Alpha = 1;
			clip( tex2DNode22.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
662.4;80.8;865;707;-498.2247;-124.2249;1.659875;True;False
Node;AmplifyShaderEditor.RangedFloatNode;2;-823.285,207.4719;Float;False;Property;_Frequency;Frequency;1;0;Create;True;0;0;False;0;0;1.890532;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;1;-622.0158,-289.5423;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-833.3862,463.3297;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;0;3.511012;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;27;-779.9575,309.9459;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-504.3658,94.52716;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-611.0098,796.156;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-440.39,347.3079;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-94.5271,51.83156;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-286.2949,847.2339;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-321.2968,1142.952;Float;False;Property;_StaticLength;Static Length;4;0;Create;True;0;0;False;0;1;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;3;160.9777,224.2322;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;17;88.91297,737.8835;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;415.3798,526.1681;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;511.6145,733.4152;Float;False;Property;_Amplitude;Amplitude;3;0;Create;True;0;0;False;0;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;833.7906,583.347;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;970.0424,342.7224;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;1133.454,-205.2112;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;c1d68765822159347a72c36792d72ab3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;21;1046.47,18.15442;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1561.278,104.8034;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Alvaro/Flag Amplify;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;0;1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;1;1
WireConnection;4;1;2;0
WireConnection;7;0;27;2
WireConnection;7;1;6;0
WireConnection;8;0;4;0
WireConnection;8;1;7;0
WireConnection;14;0;12;1
WireConnection;3;0;8;0
WireConnection;17;0;14;0
WireConnection;17;1;18;0
WireConnection;20;0;3;0
WireConnection;20;1;17;0
WireConnection;10;0;20;0
WireConnection;10;1;9;0
WireConnection;28;0;1;3
WireConnection;28;1;10;0
WireConnection;21;0;1;1
WireConnection;21;1;1;2
WireConnection;21;2;28;0
WireConnection;0;0;22;0
WireConnection;0;2;22;0
WireConnection;0;10;22;4
WireConnection;0;11;21;0
ASEEND*/
//CHKSM=AA6076066EC635025D117FFAD799B6019661F1AC