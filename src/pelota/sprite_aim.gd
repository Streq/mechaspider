extends Node2D
onready var dots: Node2D = $dots
onready var ray_cast_2d: RayCast2D = $RayCast2D


func _process(delta: float) -> void:
	ray_cast_2d.force_raycast_update()
	var collision_point = to_local(ray_cast_2d.get_collision_point())
	for dot in dots.get_children():
		dot.visible = collision_point.x>dot.position.x
		dot.global_rotation = 0
		
