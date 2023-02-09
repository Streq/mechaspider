extends Node

enum MODE {
	MOUSE,
	KEYBOARD,
	JOYSTICK
}
var mode = MODE.MOUSE

func _unhandled_input(event: InputEvent) -> void:
	if "input_state" in get_parent():
		var state = get_parent().input_state
		if is_game_event(event):
			decide_input_mode(event)
		if event.is_action("A"):
			state.A.pressed = event.is_pressed()
		if event.is_action("B"):
			state.B.pressed = event.is_pressed()

func _physics_process(delta: float) -> void:
	match mode:
		MODE.MOUSE:
			var dist_to_mouse = get_parent().get_global_mouse_position()-get_parent().global_position
			get_parent().input_state.dir = dist_to_mouse.limit_length()
			get_parent().input_state.aim_dir = dist_to_mouse.limit_length()
		MODE.KEYBOARD,MODE.JOYSTICK:
			get_parent().input_state.dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
			get_parent().input_state.aim_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
func is_game_event(event:InputEvent)->bool:
	for action in ["ui_left","ui_right","ui_down","ui_up","A","B"]:
		if event.is_action(action):
			return true
	return false

func decide_input_mode(event:InputEvent):
	if event is InputEventKey:
		mode = MODE.KEYBOARD
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		mode = MODE.JOYSTICK
	else:
		mode = MODE.MOUSE
