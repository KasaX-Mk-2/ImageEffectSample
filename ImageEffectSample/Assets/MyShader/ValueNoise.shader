Shader "Custom/ValueNoise"
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
				//0～1の乱数取得
				return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453 * _Time.y);
			}

			float valueNoise(fixed2 st)
			{
				fixed2 p = floor(st);
				fixed2 f = frac(st);

				float v00 = rand(p + fixed2(0, 0));
				float v10 = rand(p + fixed2(1, 0));
				float v01 = rand(p + fixed2(0, 1));
				float v11 = rand(p + fixed2(1, 1));
			
				fixed2 u = smoothstep(0, 1, f);			

				float v0010 = lerp(v00, v10, u.x);
				float v0111 = lerp(v01, v11, u.x);

				return lerp(v0010, v0111, u.y);
			}

			sampler2D _MainTex;
			float _Size;
			float _NoiseVal;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb = _NoiseVal*valueNoise(i.uv*_Size) + (1 - _NoiseVal)*col.rgb;

				return col;
			}
			ENDCG
		}
	}
}
