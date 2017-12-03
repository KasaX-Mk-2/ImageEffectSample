Shader "Custom/Burrar"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BurrarStlength("Stlength", Float) = 1
	}

	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		CGINCLUDE
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
		float _BurrarStlength;

		float Gauss(int no)
		{
			return exp(-0.5f*(no*no)/_BurrarStlength);
		}

		//ピクセル座標->UV座標に変換
		float2 PxToUV(float x, float y)
		{
			return float2(x/_ScreenParams.x, y/_ScreenParams.y);
		}

		fixed4 GaussX(v2f i, float total)
		{
			fixed4 col = tex2D(_MainTex, i.uv + PxToUV(0, 0))*(Gauss(0)/total);

			//左右10画素(自分含む)にガウス値を割り当てて加算する

			col+= tex2D(_MainTex, i.uv + PxToUV(1, 0))*(Gauss(1)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(-1, 0))*(Gauss(1)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(2, 0))*(Gauss(2)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(-2, 0))*(Gauss(2)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(3, 0))*(Gauss(3)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(-3, 0))*(Gauss(3)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(4, 0))*(Gauss(4)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(-4, 0))*(Gauss(4)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(5, 0))*(Gauss(5)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(-5, 0))*(Gauss(5)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(6, 0))*(Gauss(6)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(-6, 0))*(Gauss(6)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(7, 0))*(Gauss(7)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(-7, 0))*(Gauss(7)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(8, 0))*(Gauss(8)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(-8, 0))*(Gauss(8)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(9, 0))*(Gauss(9)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(-9, 0))*(Gauss(9)/total);

			return col;
		}

		fixed4 GaussY(v2f i, float total)
		{
			fixed4 col = tex2D(_MainTex, i.uv + PxToUV(0, 0))*(Gauss(0)/total);

			//上下10画素(自分含む)にガウス値を割り当てて加算する

			col+= tex2D(_MainTex, i.uv + PxToUV(0, 1))*(Gauss(1)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, -1))*(Gauss(1)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, 2))*(Gauss(2)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, -2))*(Gauss(2)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, 3))*(Gauss(3)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, -3))*(Gauss(3)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, 4))*(Gauss(4)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, -4))*(Gauss(4)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, 5))*(Gauss(5)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, -5))*(Gauss(5)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, 6))*(Gauss(6)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, -6))*(Gauss(6)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, 7))*(Gauss(7)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, -7))*(Gauss(7)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, 8))*(Gauss(8)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, -8))*(Gauss(8)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, 9))*(Gauss(9)/total);
			col+= tex2D(_MainTex, i.uv + PxToUV(0, -9))*(Gauss(9)/total);

			return col;
		}

		fixed4 Burrar(v2f i, bool is_X)
		{
			fixed4 orijin = tex2D(_MainTex, i.uv);

			if(_BurrarStlength == 0)
				return orijin;
			
			float total = 0;
			for(float j = 0; j < 10; j++)
			{
				float weight = Gauss(j);
				if(j > 0)
					total+=2.0f*weight;
				else
					total+=weight;
			}

			fixed4 col = orijin;
			if(is_X)
				col = GaussX(i, total);
			else
				col = GaussY(i, total);
			
			return col;
		}

		fixed4 fragH (v2f i) : SV_Target
		{
			return Burrar(i, true);
		}

		fixed4 fragV (v2f i) : SV_Target
		{
			return Burrar(i, false);
		}
		ENDCG

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragH
			
			#include "UnityCG.cginc"
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragV
			
			#include "UnityCG.cginc"
			ENDCG
		}
	}
}
