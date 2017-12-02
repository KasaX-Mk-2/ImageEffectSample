Shader "Custom/Bloom"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Intencity("Intencity", Float) = 0
		_BorderLine("BorderLine", Float) = 0
	}

	SubShader
	{
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
			
			sampler2D _MainTex;
			float _Intencity;
			float _BorderLine;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				//輝度を取得
				fixed4 mono = col.r*0.3 + col.g*0.6 + col.b*0.1;

				//輝度が一定値以上のもののみ、色を足す
				if(mono.r >= _BorderLine)
					col += col*mono*_Intencity;

				return col;
			}
			ENDCG
		}
	}
}
