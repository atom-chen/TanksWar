// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Skybox/CustomMovingSkybox" {
	Properties{
		_Tint("Tint Color", Color) = (.5, .5, .5, .5)
		_moveSpeed("Moving Speed",float)=1
		[NoScaleOffset] _FrontTex("Front [+Z]", 2D) = "grey" {}
		[NoScaleOffset] _BackTex("Back [-Z]", 2D) = "grey" {}
		[NoScaleOffset] _LeftTex("Left [+X]", 2D) = "grey" {}
		[NoScaleOffset] _RightTex("Right [-X]", 2D) = "grey" {}
		[NoScaleOffset] _UpTex("Up [+Y] ", 2D) = "grey" {}
		[NoScaleOffset] _DownTex("Down [-Y]", 2D) = "grey" {}
	}

		SubShader{
		Tags{ "Queue" = "Background" "RenderType" = "Background" "PreviewType" = "Skybox" }
		Cull Off ZWrite Off

		CGINCLUDE
#include "UnityCG.cginc"

		half4 _Tint;
	float _moveSpeed;

	float4 RotateAroundYInDegrees(float4 vertex, float degrees)
	{
		float alpha = degrees * UNITY_PI / 180.0;
		float sina, cosa;
		sincos(alpha, sina, cosa);
		float2x2 m = float2x2(cosa, -sina, sina, cosa);
		return float4(mul(m, vertex.xz), vertex.yw).xzyw;
	}

	struct appdata_t {
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
	};
	struct v2f {
		float4 vertex : SV_POSITION;
		float2 texcoord : TEXCOORD0;
	};
	v2f vert(appdata_t v)
	{
		v2f o;
		float rotation =  (_Time.y*_moveSpeed )%360;
		o.vertex = UnityObjectToClipPos(RotateAroundYInDegrees(v.vertex, rotation));
		o.texcoord = v.texcoord;
		return o;
	}
	half4 skybox_frag(v2f i, sampler2D smp )
	{
		half4 tex = tex2D(smp, i.texcoord);
		half3 c = tex.rgb;
		c = c * _Tint.rgb; 
		return half4(c, tex.a);
	}
	ENDCG

		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
		sampler2D _FrontTex;

	half4 frag(v2f i) : SV_Target{ return skybox_frag(i,_FrontTex); }
		ENDCG
	}
		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
		sampler2D _BackTex;

	half4 frag(v2f i) : SV_Target{ return skybox_frag(i,_BackTex); }
		ENDCG
	}
		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
		sampler2D _LeftTex;

	half4 frag(v2f i) : SV_Target{ return skybox_frag(i,_LeftTex); }
		ENDCG
	}
		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
		sampler2D _RightTex;

	half4 frag(v2f i) : SV_Target{ return skybox_frag(i,_RightTex); }
		ENDCG
	}
		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
		sampler2D _UpTex;

	half4 frag(v2f i) : SV_Target{ return skybox_frag(i,_UpTex); }
		ENDCG
	}
		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
		sampler2D _DownTex;

	half4 frag(v2f i) : SV_Target{ return skybox_frag(i,_DownTex); }
		ENDCG
	}
	}
}
