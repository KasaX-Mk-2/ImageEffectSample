Shader "Custom/DistorsionCircle"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Wave ("Wave", float) = 0
		_Length ("Length", Range(0, 1)) = 0.25
		_Distorsion ("Distorsion", float) = 0
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

			float _Length;
			float _Distorsion;
			float _Wave;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 distUV = i.uv;
			
				if(_Distorsion != 0) 
				{
					//中央からの座標をとる
					float2 center = 0.5;
					float2 relate_UV = i.uv - center;
					float dist_length = length(relate_UV);

					//一定距離内にある場合
					if (_Distorsion != 0 && dist_length <= _Length) 
					{
						//波の強さを設定
						float wave_rate = abs(sin(dist_length / _Distorsion * 90 - _Wave));
						//中央からの角度をとって波の強さと掛ける
						float relate_Angle = atan2(relate_UV.y, relate_UV.x) * wave_rate;

						//角度→方向に変換してuvを歪ませる
						distUV = float2(cos(relate_Angle), sin(relate_Angle)) * length(relate_UV);
						distUV +=center;
					}
				}

				fixed4 col = tex2D(_MainTex, distUV);
				return col;
			}

			ENDCG
		}
	}
}
