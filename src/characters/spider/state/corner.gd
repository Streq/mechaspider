extends CharacterState
onready var corner_detect: RayCast2D = $"%corner_detect"
onready var stick_to_wall: Node = $"%stick_to_wall"

func _enter(params):
	root.pivot.rotation = PI/2 + corner_detect.get_collision_normal().angle()
	root.move_and_collide(corner_detect.get_collision_normal()*6)
	root.move_and_collide(corner_detect.get_collision_normal().rotated(PI/2*root.facing_dir)*6)
	root.move_and_collide(-corner_detect.get_collision_normal()*6)
	stick_to_wall.enabled = true

func _physics_update(delta):
#	if root.animation_player.is_playing():
#		return
	
	if !root.is_on_wall():
		goto("air")
		return
	
	
	var input_dir : Vector2 = root.input_state.dir
	
	var rotated_input_dir = input_dir.rotated(-root.pivot.rotation)
	
		
	if !is_equal_approx(rotated_input_dir.x,0):
#		print(rotated_input_dir)
		root.facing_dir = rotated_input_dir.x
		goto("walk")
		return
	if !is_equal_approx(rotated_input_dir.y,0) and rotated_input_dir.y > 0:
		root.facing_dir = rotated_input_dir.y*-root.facing_dir
		goto("walk")
		return
	
	root.velocity = Vector2.DOWN.rotated(root.pivot.rotation)
	
