extends State

export var pin_claw_path : NodePath
onready var pin_claw: RopePin = get_node(pin_claw_path)

onready var lifetime: Timer = $lifetime

# Initialize the state. E.g. change the animation
func _enter(params):
	var wearer = root.wearer
	var dir : Vector2 = params[0]
	root.animation_player.play(name)
	lifetime.connect("timeout",self,"goto",["retrieving"])
	root.grab_area.connect("body_entered",self,"_on_grabbed_something")
	root.wearer_detect_area.connect("body_entered",self,"_on_touching_someone")
	root.global_position = wearer.global_position+dir*root.distance_from_wearer
	root.global_rotation = dir.angle()
	root.velocity = root.wearer.linear_velocity+dir*root.throw_speed
	call_deferred("reparent_to_world")

func reparent_to_world():
	NodeUtils.reparent_keep_transform(root, root.wearer.get_parent())

# Clean up the state. Reinitialize values like a timer
func _exit():
	lifetime.disconnect("timeout",self,"goto")
	root.grab_area.disconnect("body_entered",self,"_on_grabbed_something")
	root.wearer_detect_area.disconnect("body_entered",self,"_on_touching_someone")
	
	
# Called during _physics_process
func _physics_update(delta: float):
	root.velocity = root.move_and_slide(root.velocity)
#	root.global_position += root.velocity*delta
	var pull_direction = pin_claw.get_pull_direction()
	root.velocity += pull_direction*root.throw_decceleration*delta
	root.velocity *= (1.0-delta*root.throw_drag)
	root.global_rotation = (-pull_direction).angle()
	if !root.wearer.input_state.A.is_pressed():
		goto("retrieving")
		return
	
		
		
func _on_grabbed_something(body):
	goto_args("grabbing",[body])

func _on_touching_someone(body):
	if !root.moving_away_from_wearer() and body == root.wearer:
		goto("idle")

