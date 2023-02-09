extends CharacterState
onready var stick_to_wall: Node = $"%stick_to_wall"


func _enter(params):
	stick_to_wall.enabled = true

func _physics_update(delta):
	
	var input_dir : Vector2 = root.input_state.dir
	
	var rotated_input_dir = input_dir.rotated(-root.pivot.rotation)
	
	if root.input_state.B.is_just_pressed():
		root.velocity = Vector2.UP.rotated(root.pivot.rotation)*100.0
		goto("air")
		return
		
	if !root.is_on_wall():
		goto("air")
		return
	
	if !is_equal_approx(rotated_input_dir.x,0):
#		print(rotated_input_dir.x)
		root.facing_dir = rotated_input_dir.x
		goto("walk")
		return
	
	
	
