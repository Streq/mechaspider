extends State

#OVERRIDABLE

# Initialize the state. E.g. change the animation
func _enter(params):
	if params:
		dir = params[0]
	root.animation_player.play(name)
#	root.hide()
	call_deferred("reparent_to_wearer")
func reparent_to_wearer():
	#claw reparented to us
	NodeUtils.reparent(root, root.wearer)
	root.position = Vector2()

# Clean up the state. Reinitialize values like a timer
func _exit():
#	root.show()
	pass
# Called during _physics_process
var dir = Vector2.RIGHT
func _physics_update(delta: float):
	var wearer = root.wearer
#	if !is_instance_valid(wearer):
#		return
	var input_dir = root.wearer.input_state.aim_dir
	if input_dir:
		dir = spin_toward_dir(dir,input_dir,delta)
	root.global_position = wearer.global_position+dir*root.distance_from_wearer
	root.global_rotation = dir.angle()
	
	if owner.wearer.input_state.A.is_just_pressed():
		goto_args("throw",[dir])

func spin_toward_dir(dir,input_dir,delta):
	var current_angle = dir.angle()
	var target_angle = input_dir.angle()
	return Vector2.RIGHT.rotated(lerp_angle(current_angle,target_angle,20.0*delta))
#	return Vector2.RIGHT.rotated(Math.approach_angle(current_angle,target_angle,delta*10.0))
	
