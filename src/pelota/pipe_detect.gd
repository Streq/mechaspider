extends Area2D
onready var bar_pivot: Node2D = $"../display/bar_pivot"

func _physics_process(delta: float) -> void:
	bar_pivot.visible = !get_overlapping_areas().size()
