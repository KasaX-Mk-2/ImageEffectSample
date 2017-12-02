Shader "Custom/ParlinNoise"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseVal ("NoiseVal", Range(0, 1)) = 0.5
		_Size ("Size", Float) = 1
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

			float rand01(float2 co) 
			{
				//0～1の乱数取得
				return frac(sin(dot(co.xy, float2(12.9898, 78.233)))*43758.5453*_Time.y);
			}

			float rand11(float2 co)
			{
				//-1～1の乱数取得 
				return -1.0 + 2.0*rand01(co);
			}

			float parlinNoise(fixed2 st)
			{
				fixed2 p = floor(st);
				fixed2 f = frac(st);

				float v00 = rand11(p + fixed2(0, 0));
				float v10 = rand11(p + fixed2(1, 0));
				float v01 = rand11(p + fixed2(0, 1));
				float v11 = rand11(p + fixed2(1, 1));
			
				fixed2 u = smoothstep(0, 1, f);			

				float v0010 = lerp(dot(v00, f - fixed2(0, 0)), dot(v10, f - fixed2(1, 0)), u.x);
				float v0111 = lerp(dot(v01, f - fixed2(0, 1)), dot(v11, f - fixed2(1, 1)), u.x);

				return lerp(v0010, v0111, u.y);
			}

			float fbmNoise(fixed2 st)
			{
				float fbm = 0;

				fixed2 uv = st;

				//解像度の異なるノイズを掛け合わせる(影響度は小さくしていく)
				fbm += 0.5*parlinNoise(uv);
				uv = uv*2;

				fbm += 0.25*parlinNoise(uv);
				uv = uv*2;
				
				fbm += 0.125*parlinNoise(uv);
				uv = uv*2;
				
				fbm += 0.0625*parlinNoise(uv);

				return fbm;
			}
			
			sampler2D _MainTex;
			float _Size;
			float _NoiseVal;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				float3 noise = fbmNoise(i.uv*_Size);

				col.rgb = _NoiseVal*noise + (1 - _NoiseVal)*col.rgb;

				return col;
			}
			ENDCG
		}
	}
}