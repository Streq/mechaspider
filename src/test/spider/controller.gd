extends Node

func _unhandled_input(event: InputEvent) -> void:
	if "input_state" in get_parent():
		var state = get_parent().input_state
		if event.is_action("A"):
			state.A.pressed = event.is_pressed()
		if event.is_action("B"):
			state.B.pressed = event.is_pressed()

func _physics_process(delta: float) -> void:
	var dist_to_mouse = get_parent().get_global_mouse_position()-get_parent().global_position
	get_parent().input_state.aim_dir = dist_to_mouse.limit_length()
	get_parent().input_state.dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
