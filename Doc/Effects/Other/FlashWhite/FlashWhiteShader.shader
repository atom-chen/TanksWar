// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/FlashWhite"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_LuminosityAmount("GrayScale Amount",Range(0.0,1.0))=1.0
	}
	SubShader
	{

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed _LuminosityAmount;
			float4 _MainTex_ST;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			////红*0.299，绿*0.587，蓝*0.114，来获取一个亮度值（也就是颜色深浅值）luminosity 
			fixed4 frag (v2f i) : COLOR
			{
				// sample the texture
				fixed4 renderTex = tex2D(_MainTex, i.uv);
				
				float luminosity=0.149*renderTex.r+0.1294*renderTex.g+0.1294*renderTex.b;
				fixed4 finalColor=lerp(renderTex,luminosity,_LuminosityAmount);
						
				return finalColor;
			}
			ENDCG
		}
	}

	FallBack "Diffuse"
}
