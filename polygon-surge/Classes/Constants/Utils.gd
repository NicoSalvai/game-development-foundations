class_name Utils

const DEBUG_LOG: bool = true
const ENABLED_COMPONENTS: Array[String] = [
	#"BulletPool",
	"Unkown"
]

static func debug_log(log: String, source: String = "Unknown") -> void:
	if DEBUG_LOG and source in ENABLED_COMPONENTS:
		print("[%s]: %s" % [source, log])
