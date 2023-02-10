extends Node2D

export var distance = 100.0
var arc_degrees := 180.0

onready var sprite: Sprite = $Sprite

func jump():
	pass

func _physics_process(delta: float) -> void:
	if !owner.is_on_wall():
		hide()
		return
	show()
	var position_in_circle :Vector2 = get_local_mouse_position().limit_length(distance)
	
	var angle = position_in_circle.angle()
	print(rad2deg(angle))
	
	var half_arc = deg2rad(arc_degrees)/2
	
	angle = clamp(angle,-half_arc,half_arc)
	
	var position_in_arc := position_in_circle
	
	if angle == -half_arc or angle == +half_arc:
		position_in_arc = (Vector2.DOWN*position_in_circle.y)
	
	
	sprite.position = position_in_arc
	
	if owner.input_state.B.is_just_pressed():
		owner.velocity = (Vector2.RIGHT).rotated(global_rotation+angle*owner.facing_dir)*position_in_arc.length()/distance*500.0
		return
		
	
