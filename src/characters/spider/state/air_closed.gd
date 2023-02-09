extends CharacterState
onready var stick_to_wall: Node = $"%stick_to_wall"

func _enter(params) -> void:
	root.pivot.rotation = 0
	stick_to_wall.enabled = false

func _physics_update(delta):
	if root.is_on_wall():
		root.velocity *= 1.0-delta*5.0
		
	root.velocity += root.gravity*delta
	
	if !root.input_state.B.is_pressed():
		goto("air")
		return
	
	
