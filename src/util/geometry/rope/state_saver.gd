extends Node2D

export var camera_path : NodePath
export var rope_path : NodePath

onready var camera :Camera2D = get_node(camera_path)
onready var rope :Node2D = get_node(rope_path)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var keyboard_event:InputEventKey = event
		if event.scancode == KEY_S:
			print(rope.line_points)
			print(camera.zoom_factor)
			print(camera.global_position)
