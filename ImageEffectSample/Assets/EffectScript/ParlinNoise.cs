using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParlinNoise : CustomImageEffect
{
	[SerializeField, Range(0, 1)]
	private float m_NoiseValue = 0.5f;
	[SerializeField, Header("ノイズのブロックサイズ")]
	private float m_BlockSize = 0.5f;

	protected override void UpdateMaterial()
	{
		m_Material.SetFloat("_NoiseVal", m_NoiseValue);
		m_Material.SetFloat("_Size", m_BlockSize);
	}
}