extends Node2D

onready var playjam_instructions: VBoxContainer = $labels_pivot/playjam_instructions
onready var non_playjam_instructions: Label = $labels_pivot/non_playjam_instructions


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Playjam.is_playjam():
		playjam_instructions.show()
		non_playjam_instructions.hide()
	else:
		playjam_instructions.hide()
		non_playjam_instructions.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
