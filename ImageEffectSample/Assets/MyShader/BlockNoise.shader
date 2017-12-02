Shader "Custom/BlockNoise"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseVal ("NoiseVal", Range(0, 1)) = 0.5
		_Size ("Size", Float) = 1
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

			float rand(float2 co) 
			{
			    //0~1の乱数取得(計算法は今のところ不明) 
		        return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
	        }

			sampler2D _MainTex;
			float _Size;
			float _NoiseVal;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);

				//指定したブロック個数ごとにノイズを分ける
				float3 block = rand(floor(i.uv *_Size)*_Time.y);

				/*/個数じゃなくてピクセルサイズで区切りたい場合はこっちで
				float2 fact = i.uv * _ScreenParams.xy;
                float2 scuv = (floor(fact / _Size + 0.5) * _Size) / _ScreenParams.xy;
				float3 block = rand(scuv * _Time.y);
				*/

				col.rgb =  _NoiseVal*block + (1 - _NoiseVal)*col.rgb;

				return col;
			}
			ENDCG
		}
	}
}
