extends ColorRect
tool

func _ready() -> void:
	rect_rotation = 0
	var rect_owner :CollisionShape2D = get_parent()
	var rect : RectangleShape2D = rect_owner.shape
	self.rect_size = rect.extents*2
	self.rect_position = -rect.extents
