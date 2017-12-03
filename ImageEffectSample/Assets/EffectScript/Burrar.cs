using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Burrar : CustomImageEffect
{
	[SerializeField, Range(0, 100), Header("一回当たりのブラーの強さ")]
	private float m_BurrarValue = 0;
	[SerializeField, Range(1, 10), Header("ぼかしを行う回数")]
	private int m_BurrarCount = 1;

	protected override void UpdateMaterial()
	{
		m_Material.SetFloat("_BurrarStlength", m_BurrarValue);
	}

	protected override void SetEffect(RenderTexture source, RenderTexture destination)
	{
		//最初に現在のレンダリング結果(何もしてない)を取得
		RenderTexture rt = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);

		for (int i = 0 ; i < m_BurrarCount ; i++)
		{
			RenderTexture rt2 = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);

			//最初に横方向にぼかしをかける
			if (i == 0)
				Graphics.Blit(source, rt2, m_Material, 0);
			else
			{
				Graphics.Blit(rt, rt2, m_Material, 0);
				RenderTexture.ReleaseTemporary(rt);
			}

			rt = rt2;

			//次に縦方向にぼかす
			rt2 = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);
			Graphics.Blit(rt, rt2, m_Material, 1);
			RenderTexture.ReleaseTemporary(rt);
			rt = rt2;

			//これを繰り返す
		}

		//終わったらレンダリング
		Graphics.Blit(rt, destination, m_Material);
		RenderTexture.ReleaseTemporary(rt);
	}
}