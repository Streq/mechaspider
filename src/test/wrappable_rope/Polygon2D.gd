extends Polygon2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	yield(parent,"ready")
	polygon = parent.polygon
	global_transform = parent.global_transform
