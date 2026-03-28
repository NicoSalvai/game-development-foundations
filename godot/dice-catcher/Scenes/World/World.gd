extends Node


@onready var hobbit: Hobbit = $Hobbit
@onready var wizard: Wizard = $Wizard


func _ready() -> void:
	hobbit.hit_wizard.connect(_on_hobbit_hit_wizard, 4)
	wizard.cast_spell.connect(_on_wizard_cast_spell, 4)

func _on_wizard_cast_spell() -> void:
	print("_on_wizard_cast_spell")
	hobbit.hit_by_spell()


func _on_hobbit_hit_wizard() -> void:
	print("_on_hobbit_hit_wizard")
	wizard.hitted()
