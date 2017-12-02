using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mozaic : CustomImageEffect
{
	[SerializeField, Range(1, 100)]
	private float Size = 1;

	protected override void UpdateMaterial()
	{
		m_Material.SetFloat("_Size", Size);
	}
}
