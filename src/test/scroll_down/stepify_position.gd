extends Node2D

export var step := 32.0
export (NodePath) onready var relative_to = get_node(relative_to) as Node2D

func _physics_process(delta: float) -> void:
	global_position.y = stepify(relative_to.global_position.y, step)
