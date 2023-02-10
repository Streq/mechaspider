extends Label

func _process(delta: float) -> void:
	text = str(get_parent().global_position)
