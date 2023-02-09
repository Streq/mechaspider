extends Node

export var always_hide = false

func _ready():
	yield(get_parent(),"ready")
	get_parent().visible = !always_hide and OS.is_debug_build()

