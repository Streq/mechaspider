extends State

export var rope_pin_wearer_path : NodePath
onready var rope_pin_wearer : RopePin = get_node(rope_pin_wearer_path)
export var rope_pin_claw_path : NodePath
onready var rope_pin_claw : RopePin = get_node(rope_pin_claw_path)

func _enter(params):
	var grabbed = params[0]
	root.animation_player.play(name)
	call_deferred("reparent_to_grabbed",grabbed)
	root.velocity = Vector2()

func reparent_to_grabbed(grabbed):
	NodeUtils.reparent_keep_transform(root, grabbed)
	

# Clean up the state. Reinitialize values like a timer
func _exit():
	return
	
# Called during _physics_process
func _physics_update(delta: float):
	if !root.wearer.input_state.A.is_pressed():
		goto("retrieving")
		return
	
	var pull_direction = rope_pin_wearer.get_pull_direction()
	root.wearer.apply_central_impulse(pull_direction*root.pull_force*delta)

#	root.wearer.apply_central_impulse(root.wearer.global_position.direction_to(root.global_position)*root.pull_force*delta)
