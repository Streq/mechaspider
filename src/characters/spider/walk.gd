extends CharacterState
signal advance
onready var no_more_floor_detect: RayCast2D = $"%no_more_floor_detect"
onready var corner_detect: RayCast2D = $"%corner_detect"
onready var stick_to_wall: Node = $"%stick_to_wall"

var queued_goto = null
var queued_params = null

func _enter(params):
	turning = false
	queue_goto(null,null)
	stick_to_wall.enabled = true
	

func _physics_update(delta):
	if queued_goto:
		if queued_params:
			goto_args(queued_goto,queued_params)
			return
		goto(queued_goto)
		return
	
	if turning:
		return
	
	if root.input_state.B.is_just_pressed():
		root.velocity = Vector2(root.facing_dir,-1).rotated(root.pivot.rotation)*100.0
		goto("air")
		return
	
	
	if !root.is_on_wall():
		goto("air")
		return
	
	root.velocity = Vector2.DOWN.rotated(root.pivot.rotation)
	var input_dir : Vector2 = root.input_state.dir
	
	
	var rotated_input_dir = input_dir.rotated(-root.pivot.rotation)
	
	
	if is_equal_approx(rotated_input_dir.x,0.0):
		goto("idle")
		return
#	print(rotated_input_dir)
	
	root.facing_dir = rotated_input_dir.x
	pass

var turning = false
func advance(step_size := 1.0):
	emit_signal("advance")
	if root.state_machine.current != self:
		return
#	print("advancing")
	var r :KinematicBody2D = root
	var collision = r.move_and_collide(Vector2(root.facing_dir*step_size, 0.0).rotated(root.pivot.rotation))
	if collision:
#		print(collision)
#		root.pivot.rotation = Vector2(root.facing_dir,0)
#		print(collision.normal)
		turning = true
#		yield(self,"advance")
		queue_goto("corner_concave",[collision])
#		print("corner_concave")
		return
	else:
		no_more_floor_detect.force_raycast_update()
		if !no_more_floor_detect.is_colliding():
			corner_detect.force_raycast_update()
			if corner_detect.is_colliding():
				turning = true
#				yield(self,"advance")
				queue_goto("corner")
				return

func queue_goto(state, params = null):
	queued_goto = state
	queued_params = params
