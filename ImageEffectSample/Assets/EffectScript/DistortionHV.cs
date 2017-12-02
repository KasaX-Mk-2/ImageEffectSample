using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DistortionHV : CustomImageEffect
{
	[SerializeField]
	private float m_SetSpaceX;
	[SerializeField, Range(0, 1)]
	private float m_DistortionX;
	[SerializeField, Range(0, 1)]
	private float m_OffSetX;

	[SerializeField]
	private float m_SetSpaceY;
	[SerializeField, Range(0, 1)]
	private float m_DistortionY;
	[SerializeField, Range(0, 1)]
	private float m_OffSetY;


	protected override void UpdateMaterial()
	{
		m_Material.SetFloat("_SetSpaceX", m_SetSpaceX);
		m_Material.SetFloat("_SetSpaceY", m_SetSpaceY);
		m_Material.SetFloat("_DistortionX", m_DistortionX);
		m_Material.SetFloat("_DistortionY", m_DistortionY);
		m_Material.SetFloat("_OffSetX", m_OffSetX);
		m_Material.SetFloat("_OffSetY", m_OffSetY);
	}
}
