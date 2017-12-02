using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DistortionCircle : CustomImageEffect
{
	[SerializeField, Range(0, 1)]
	private float m_Length = 0.25f;
	[SerializeField]
	private float m_Distorsion = 0.5f;
	[SerializeField, Range(0, 100)]
	private float m_Wave = 0;

	protected override void UpdateMaterial()
	{
		m_Material.SetFloat("_Length", m_Length);
		m_Material.SetFloat("_Wave", m_Wave);
		m_Material.SetFloat("_Distorsion", m_Distorsion);
	}
}