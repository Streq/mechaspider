extends CanvasLayer


func _process(delta: float) -> void:
	offset = owner.get_viewport_transform().get_origin().posmod(32)
