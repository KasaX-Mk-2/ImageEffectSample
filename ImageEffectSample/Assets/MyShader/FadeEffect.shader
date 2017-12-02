// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/FadeEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Value ("Value", Range(-1.5, 1)) = 0
		_FadeColor("FadeColor", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
	    Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha

		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

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
				o.uv = v.uv;
				return o;
			}

			float _Value;
			float4 _FadeColor;

			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
			    //画面中央からの距離を計算
			    float2 center = 0.5;
			    float leng = distance(center, i.uv) * 2;
			    //距離とValueを掛け合わせて透明度を決定
				fixed4 col = _FadeColor;

				float rate = clamp(leng + _Value, 0, 1);

				return tex2D(_MainTex, i.uv) * (1 - rate) + col * rate;
			}
			ENDCG
		}
	}
}
