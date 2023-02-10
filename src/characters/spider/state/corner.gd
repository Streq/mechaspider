extends CharacterState
onready var corner_detect: RayCast2D = $"%corner_detect"
onready var stick_to_wall: Node = $"%stick_to_wall"

export var jump_speed := 100.0
var turning = false


func _enter(params):
	corner_detect.force_raycast_update()
	
	var collision_normal = corner_detect.get_collision_normal()
	var collision_point = corner_detect.get_collision_point()
	
	var r : RayCast2D = corner_detect
	
	var rotation = root.pivot.global_rotation
	
	var pivot_xform : Transform2D = root.pivot.transform
	
	var global_position_rotated = pivot_xform.xform_inv(root.global_position)
	var collision_point_rotated = pivot_xform.xform_inv(collision_point)
	
	var alpha := Vector2()
	alpha.y = global_position_rotated.y+6.0
	alpha.x = collision_point_rotated.x+6.0
	root.global_position = pivot_xform.xform(alpha)

	root.pivot.global_rotation = PI/2 + collision_normal.angle()
	
	stick_to_wall.enabled = true
	turning = false
	
func _physics_update(delta):
	
	if !root.is_on_wall():
		goto("air")
		return
		
	if root.input_state.B.is_just_pressed():
		root.velocity = Vector2(-root.facing_dir,-1).rotated(root.pivot.rotation)*jump_speed
		goto("air")
		return
	
	var input_dir : Vector2 = root.input_state.dir
	
	var rotated_input_dir = input_dir.rotated(-root.pivot.rotation)

	
	if !is_equal_approx(rotated_input_dir.x,0):
		if sign(rotated_input_dir.x) == root.facing_dir:
			root.facing_dir = rotated_input_dir.x
			goto("walk")
			return
		else:
			root.facing_dir = rotated_input_dir.x
			goto("walk")
			return
	if !is_equal_approx(rotated_input_dir.y,0) and rotated_input_dir.y > 0:
		root.facing_dir = rotated_input_dir.y*-root.facing_dir
		goto("walk")
		return
	
	root.velocity = Vector2.DOWN.rotated(root.pivot.rotation)
	
