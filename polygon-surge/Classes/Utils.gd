class_name Utils

const DEBUG_LOG: bool = true

func debug_log(log: String, source: String = "Unknown") -> void:
	if DEBUG_LOG:
		print("[%s]: %s" % [source, log])
