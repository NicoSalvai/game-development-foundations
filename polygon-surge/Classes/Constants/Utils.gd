class_name Utils

const DEBUG_LOG: bool = true
const DISABLED_COMPONENTS: Array[String] = [
	"BulletPool"
]

static func debug_log(log: String, source: String = "Unknown") -> void:
	if DEBUG_LOG and source not in DISABLED_COMPONENTS:
		print("[%s]: %s" % [source, log])
