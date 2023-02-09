extends Node2D


export var init_size := 1500
var size = 0
export var OBJECT : PackedScene

var objects = []
var unused_objects = []
func _ready() -> void:
	for i in init_size:
		var instance = new_instance()
		instance.call_deferred("disable")
		

func get_one():
	if unused_objects.empty():
		var instance = new_instance()
		instance.call_deferred("enable")
		return instance
	
	var index = unused_objects.pop_back()
	var instance = objects[index]
	instance.enable()
	return instance
	

func new_instance():
	var instance = OBJECT.instance()
	instance.index = size
	size += 1
	objects.push_back(instance)
	call_deferred("add_child",instance)
	
