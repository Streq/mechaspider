extends Node2D

export (NodePath) onready var pointA = get_node(pointA) as RigidBody2D
export (NodePath) onready var pointB = get_node(pointB) as Node2D
export var length := 0


func _physics_process(delta: float) -> void:
	return
	var distance_vector = pointB.global_position - pointA.global_position
	var distance_squared = distance_vector.length_squared()
	
	if distance_squared>length*length:
		pointA.apply_central_impulse(distance_vector*10.0*delta)
	

func _input(event: InputEvent) -> void:
	return
	if event.is_action_pressed("A"):
		pointB.global_position = get_global_mouse_position()
