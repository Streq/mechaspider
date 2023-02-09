extends Node2D

onready var eye_pupil: Sprite = $eye_pupil
onready var input_state: Node = $"%input_state"

func _physics_process(delta: float) -> void:
	var dir = input_state.dir
	eye_pupil.position = dir*4
