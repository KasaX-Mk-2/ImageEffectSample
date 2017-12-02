using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NoiseEffect : CustomImageEffect
{
	[SerializeField, Range(0, 1)]
	private float Noise = 0;
	[SerializeField]
	private float Distortion = 0;

	[SerializeField, Range(0, 1)]
	private float WideNoise = 0;
	[SerializeField, Range(0, 1)]
	private float Offset = 0;

	[SerializeField]
	private float ScanLineTail = 0;
	[SerializeField]
	private float ScanLineTime = 0;

	protected override void UpdateMaterial()
	{
		m_Material.SetFloat("_RGBNoise", Noise);
		m_Material.SetFloat("_Distortion", Distortion);
		m_Material.SetFloat("_WideNoise", WideNoise);
		m_Material.SetFloat("_Offset", Offset);
		m_Material.SetFloat("_ScanLineTail", ScanLineTail);
		m_Material.SetFloat("_ScanLineTime", ScanLineTime);
	}
}
