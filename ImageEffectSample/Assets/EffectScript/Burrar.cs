using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Burrar : CustomImageEffect
{
	[SerializeField, Range(0, 100), Header("一回当たりのブラーの強さ")]
	private float m_BurrarValue = 0;

	[SerializeField, Header("深度を使うかどうか")]
	private bool m_UseDepth = false;
	[SerializeField, Header("深度によってぼかしの度合いを変動させるか")]
	private bool m_DepthFluctuation = false;
	[SerializeField, Header("ぼかし度合いを反転させるか")]
	private bool m_ReverseFlag = false;

	[SerializeField, Range(0, 1), Header("基準となる深度値")]
	private float m_DepthBorder = 0;
	[SerializeField, Range(1, 10), Header("ぼかしを行う回数")]
	private int m_BurrarCount = 1;

	[SerializeField]
	private Camera m_DepthCam;

	[SerializeField]
	private RenderTexture m_DepthTex;
	private RenderTexture m_ColorTex;

	void Update()
	{
		if (!m_DepthTex)
		{
			Vector2Int screen = new Vector2Int(Mathf.Min(Screen.width, 1920), Mathf.Min(Screen.height, 1080));

			// デプスバッファ用 RenderTexture
			m_DepthTex = new RenderTexture(screen.x, screen.y, 24, RenderTextureFormat.Depth);
			m_DepthTex.Create();
			m_ColorTex = new RenderTexture(screen.x, screen.y, 24, RenderTextureFormat.Depth);
			m_ColorTex.Create();

			//デプスバッファ用にカメラ用意
			m_DepthCam.depthTextureMode = DepthTextureMode.Depth;
			m_DepthCam.SetTargetBuffers(m_ColorTex.colorBuffer, m_DepthTex.depthBuffer);
		}

		//デプスバッファ用にレンダリング
		GL.invertCulling = true;
		m_DepthCam.Render();
		GL.invertCulling = false;
	}

	protected override void UpdateMaterial()
	{
		m_Material.SetFloat("_BurrarStlength", m_BurrarValue);
		m_Material.SetFloat("_DepthBorder", m_DepthBorder);
		m_Material.SetTexture("_DepthTex", m_DepthTex);
		m_Material.SetInt("_ReverseFlag", m_ReverseFlag ? 1 : 0);
		m_Material.SetInt("_UseDepth", m_UseDepth ? 1 : 0);
		m_Material.SetInt("_DepthFluctuation", m_DepthFluctuation ? 1 : 0);
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