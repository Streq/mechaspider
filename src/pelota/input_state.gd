extends Node


var A := ButtonState.new()
var B := ButtonState.new()
var dir := Vector2() setget set_dir
var aim_dir := Vector2() setget set_aim_dir

func set_dir(val:Vector2):
	dir = val.limit_length()
	
func set_aim_dir(val:Vector2):
	aim_dir = val.limit_length()

func _physics_process(delta: float) -> void:
	A.stale()
	B.stale()

func clear():
	A.stale()
	B.stale()
	dir = Vector2()
	aim_dir = Vector2()
