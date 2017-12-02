using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FadeEffect : CustomImageEffect
{
	[SerializeField]
	private Color FadeColor = Color.white;

	[SerializeField, Range(-1.5f, 1)]
	private float Value = -1.5f;

	protected override void UpdateMaterial()
	{
		m_Material.SetFloat("_Value", Value);
		m_Material.SetColor("_FadeColor", FadeColor);
	}
}
