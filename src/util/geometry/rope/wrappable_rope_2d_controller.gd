extends Node2D

onready var rope = get_parent()

var controlling_front = false
var last_pressed := "A"

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		match last_pressed:
			"A":
				move_back()
			"B":
				move_front()
			"C":
				move_both()
			
			
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left",true):
		rope.double_step(rope.line_points[0],rope.line_points[-1]+Vector2.LEFT)
	if event.is_action_pressed("ui_right",true):
		rope.double_step(rope.line_points[0],rope.line_points[-1]+Vector2.RIGHT)
	if event.is_action_pressed("ui_up",true):
		rope.double_step(rope.line_points[0],rope.line_points[-1]+Vector2.UP)
	if event.is_action_pressed("ui_down",true):
		rope.double_step(rope.line_points[0],rope.line_points[-1]+Vector2.DOWN)
	if event.is_action_pressed("A"):
		move_back()
	if event.is_action_pressed("B"):
		move_front()
	if event.is_action_pressed("C"):
		move_both()
	
func move_back():
	rope.double_step(rope.line_points[0],get_global_mouse_position())
	controlling_front = false
	last_pressed = "A"
func move_front():
	rope.double_step(get_global_mouse_position(),rope.line_points[-1])
	controlling_front = true
	last_pressed = "B"

func move_both():
	var target = get_global_mouse_position() 
	var distance = rope.line_points[-1] - rope.line_points[0]
	if controlling_front:
		rope.double_step(target, target+distance)
	else:
		rope.double_step(target-distance, target)
	last_pressed = "C"
