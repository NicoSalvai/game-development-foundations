extends Node

const WAVE_DATA_PATH: String = "res://Resources/Waves/%s.tres"

func load_wave_data(wave_name: String) -> WaveData:
	var wd: WaveData
	if ResourceLoader.exists(WAVE_DATA_PATH % wave_name):
		wd = ResourceLoader.load(WAVE_DATA_PATH % wave_name)
	return wd
