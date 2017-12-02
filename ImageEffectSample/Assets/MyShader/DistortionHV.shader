Shader "Custom/DistortionHV"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SetSpaceX("SetSpaceX", float) = 0
		_SetSpaceY("SetSpaceY", float) = 0
		_DistortionX("DistortionX", float) = 0
		_DistortionY("DistortionY", float) = 0
		_OffSetX("OffSetX", float) = 0
		_OffSetY("OffSetY", float) = 0
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
			float _SetSpaceX;
			float _SetSpaceY;
			float _DistortionX;
			float _DistortionY;
			float _OffSetX;
			float _OffSetY;

			fixed4 frag (v2f i) : SV_Target
			{
			    float2 texUV = i.uv;

				//最初は横方向にUVを歪ませる
			    float angleX = _SetSpaceX * texUV.y + _OffSetX * _SetSpaceX;
				float distX = sin(angleX) * _DistortionX/2;
				texUV.x+=distX;

				//次に縦方向に歪ませる
				float angleY = _SetSpaceY * texUV.x + _OffSetY * _SetSpaceY;
				float distY = sin(angleY) * _DistortionY/2;
				texUV.y+=distY;

				fixed4 col = tex2D(_MainTex, texUV);
				return col;
			}
			ENDCG
		}
	}
}
