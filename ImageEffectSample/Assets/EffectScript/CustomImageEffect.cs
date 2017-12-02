using UnityEngine;

[ExecuteInEditMode()]
[RequireComponent(typeof(Camera))]
public abstract class CustomImageEffect : MonoBehaviour
{
	protected Material m_Material;
    //使うシェーダー名をここで指定
	[SerializeField]
	protected Shader UseShader;

    void Start()
    {
		if (UseShader)
			m_Material = new Material (UseShader);//このスクリプト内で新しくマテリアル生成
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
		if (!UseShader)
			return;

		else if (!m_Material)
			m_Material = new Material(UseShader);

		//マテリアルのパラメータを設定
		UpdateMaterial();

		SetEffect (source, destination);
    }

	/// <summary>現在のレンダリング結果を受け取ってそれにイメージエフェクトを反映</summary>
	protected virtual void SetEffect(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, m_Material);
	}

	/// <summary>マテリアルパラメータ更新用</summary>
	protected abstract void UpdateMaterial();
}