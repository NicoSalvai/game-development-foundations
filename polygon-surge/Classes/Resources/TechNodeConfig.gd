class_name TechNodeConfig
extends Resource


@export var id: String = ""
@export var label: String = ""
@export var cost: int = 1
@export var pre_unlocked: bool = false
@export var coming_soon: bool = false
@export var requires: Array[String] = []
@export var stat: TechTreeState.Stat = TechTreeState.Stat.NONE
@export var modifier_delta: float = 0.0
