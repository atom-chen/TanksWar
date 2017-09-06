// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "GUI/TextMeshOutlineShader" {
	Properties{
		_MainTex("Font Texture", 2D) = "white" {}
		_Color("Text Color", Color) = (1,1,1,1)
		_OutlineColor("Outline Color", Color) = (1,0,0,1)
	    _Size("Outline size",float) =10
	}

		SubShader{

		Tags{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
		"PreviewType" = "Plane"
	}
		Lighting Off Cull Off ZTest Always ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
		fixed4 _OutlineColor;
		float _Size;
		struct appdata_t {
		float4 vertex : POSITION;
		fixed4 color : COLOR;
		float2 texcoord : TEXCOORD0;
	};

	struct v2f {
		float4 vertex : SV_POSITION;
		fixed4 color : COLOR;
		float2 texcoord : TEXCOORD0;
	};

	sampler2D _MainTex;
	uniform float4 _MainTex_ST;
	uniform fixed4 _Color;

	v2f vert(appdata_t v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.color = v.color * _Color;
		o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		fixed4 col = i.color;
		col.a *= tex2D(_MainTex, i.texcoord).a;


		float radiusX = _Size/_ScreenParams.x;
		float radiusY = _Size / _ScreenParams.y;
		float4 accum = float4(0.0, 0.0, 0.0, 0.0);
		float4 normal = float4(0.0, 0.0, 0.0, 0.0);

		normal = tex2D(_MainTex, float2(i.texcoord.x, i.texcoord.y));

		accum += tex2D(_MainTex, float2(i.texcoord.x - radiusX, i.texcoord.y - radiusY));
		accum += tex2D(_MainTex, float2(i.texcoord.x + radiusX, i.texcoord.y - radiusY));
		accum += tex2D(_MainTex, float2(i.texcoord.x + radiusX, i.texcoord.y + radiusY));
		accum += tex2D(_MainTex, float2(i.texcoord.x - radiusX, i.texcoord.y + radiusY));

		float u_threshold = 0.5;

		accum *= u_threshold;
		accum.rgb = _OutlineColor * accum.a;
		//accum.a = 1.0;

		normal = (accum * (1.0 - normal.a)) + (col * normal.a);

		col =  normal;//col * 

		return col;
	}
		ENDCG
	}
	}
}