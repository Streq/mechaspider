extends Node

export var step := 360

func _process(delta: float) -> void:
	get_parent().global_rotation_degrees = stepify(owner.global_rotation_degrees, step)
