extends Node


export var should_free = true


func _ready():
	if should_free:
		get_parent().queue_free() 
