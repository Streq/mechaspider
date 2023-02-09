extends Camera2D


export var zoom_factor := 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event :InputEventMouseButton = event
		if mouse_event.button_index == BUTTON_WHEEL_UP and can_zoom(-1):
			zoom_factor -= 1
			zoom_at_point(mouse_event.position)
			
		if mouse_event.button_index == BUTTON_WHEEL_DOWN and can_zoom(1):
			zoom_factor += 1
			zoom_at_point(mouse_event.position)
	
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		var mouse_motion : InputEventMouseMotion = event
		position -= mouse_motion.relative*zoom
#
#	if event.is_action_pressed("B"):
#		print("zoom_factor:", zoom_factor)
#		print("camera_global_position:", global_position)
func _physics_process(delta: float) -> void:
	self.anchor_mode


func zoom_at_point(point):
	var c0 = global_position # camera position
	var v0 = get_viewport().size # vieport size
	var c1 # next camera position
	var z0 = zoom # current zoom value
	var z1 = Vector2(1,1)*pow(1.1,zoom_factor) # next zoom value
	if z1.is_equal_approx(Vector2.ZERO):
		return
	c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
	zoom = z1
	global_position = c1

func can_zoom(amount):
	return !Vector2.ZERO.is_equal_approx(Vector2(1,1)*pow(1.1,zoom_factor+amount))

func _ready() -> void:
	zoom_at_point(get_viewport().size/2)
