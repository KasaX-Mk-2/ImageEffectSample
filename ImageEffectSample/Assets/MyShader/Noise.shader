// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Noise"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_RGBNoise ("RGBNoise", Range(0, 1)) = 0
		_Offset ("Offset", Range(0, 1)) = 0
		_Distortion ("Distortion", Float) = 0
		_WideNoise ("WideNoise", Range(0, 1)) = 0
		_ScanLineTail("Tail", Range(0, 2)) = 0.5
		_ScanLineTime("TailTime", Float) = 100
	}
	SubShader
	{
		// No culling or depth
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
			float _RGBNoise;

			float _Offset;
			float _Distortion;
			float _WideNoise;

			float _ScanLineTail;
			float _ScanLineTime;

			float rand(float2 co) 
			{
		        return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
	        }

			fixed4 frag (v2f i) : SV_Target
			{
			    float2 texUV = i.uv;
			    //UVをいじって歪ませる
				float angle = _Distortion * texUV.y + _Offset * _Distortion;
				float dist = sin(angle) * _WideNoise / 2;
				texUV.x += dist;

			    //現在の色取得
				fixed4 col = tex2D(_MainTex, texUV);
				//ランダムな色取得(毎フレーム異なる色にするため経過時間掛ける)
				float3 noise = rand(i.uv * _Time.y);

				//今の色とランダム色掛け合わせてノイズかける
				col.rgb =  (1 - _RGBNoise) * col.rgb + _RGBNoise * noise;

				//現在のスキャンライン位置取得
				float lineY = 1 - (_Time.y - floor(_Time.y / _ScanLineTime) * _ScanLineTime) / _ScanLineTime;

				//スキャンライン位置からの距離を取得
				float leng = abs(texUV.y - lineY);
				if(leng > 0.5)
					leng = 1 - leng;

				//スキャンライン位置に近いほど、黒が濃くなるように
				float line_stlength = clamp(1 - leng/0.5, 0, 1);
				col.rgb *= clamp(1 - _ScanLineTail*line_stlength, 0, 1);

				return col;
			}
			ENDCG
		}
	}
}
