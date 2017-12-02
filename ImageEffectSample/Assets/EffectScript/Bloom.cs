using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bloom : CustomImageEffect
{
	[SerializeField, Range(0, 1)]
	private float m_Intencity = 0;

	[SerializeField, Range(0, 1)]
	private float m_BorderLine = 0;

	protected override void UpdateMaterial()
	{
		m_Material.SetFloat("_Intencity", m_Intencity);
		m_Material.SetFloat("_BorderLine", m_BorderLine);
	}
}
