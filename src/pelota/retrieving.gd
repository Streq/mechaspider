extends State

export var rope_pin_wearer_path : NodePath
onready var rope_pin_wearer : RopePin = get_node(rope_pin_wearer_path)
export var rope_pin_claw_path : NodePath
onready var rope_pin_claw : RopePin = get_node(rope_pin_claw_path)

func _enter(params):
	root.animation_player.play(name)
	call_deferred("reparent_to_world")
	root.wearer_detect_area.connect("body_entered",self,"_on_touching_someone")
func reparent_to_world():
	NodeUtils.reparent_keep_transform(root, root.wearer.get_parent())

# Clean up the state. Reinitialize values like a timer
func _exit():
	root.wearer_detect_area.disconnect("body_entered",self,"_on_touching_someone")
	
# Called during _physics_process
func _physics_update(delta: float):
	var final_vel = root.velocity
	var wearer = root.wearer
	var wearer_vel = wearer.linear_velocity
	if wearer_vel.dot(root.global_position - wearer.global_position)<0.0:
		final_vel += wearer_vel
	root.move_and_slide(final_vel)
#	root.global_position += (final_vel)*delta
	
	var pull_direction = rope_pin_claw.get_pull_direction()
	
	root.move_and_slide(pull_direction*100.0)
#	var dir = root.global_position.direction_to(root.wearer.global_position)
	root.velocity += pull_direction*root.retrieve_acceleration*delta
	root.velocity *= (1.0-delta*root.retrieve_drag)
	root.rotation = (-pull_direction).angle()

func _on_touching_someone(someone):
	if someone == root.wearer:
		var dist = (root.global_position - root.wearer.global_position)
		var aiming_direction = dist.normalized()
		goto_args("idle",[aiming_direction])
