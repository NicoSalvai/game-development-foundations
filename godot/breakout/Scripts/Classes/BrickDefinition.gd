class_name BrickDefinition 
extends Resource

@export var max_health: int = 1
@export var points: int  = 10
@export var color: BrickColor = BrickColor.BLUE
@export var is_unbreakable: bool = false
@export var power_up: BrickDefinition.PowerUp = BrickDefinition.PowerUp.NONE 

enum BrickColor {GREY, BLUE, GREEN, PURPLE, RED, YELLOW}
enum PowerUp {NONE, MULTI_BALL, STRONG_BALL}
