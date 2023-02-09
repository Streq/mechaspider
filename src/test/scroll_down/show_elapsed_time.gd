extends Label

onready var start_microseconds = Time.get_ticks_usec()


func _physics_process(delta: float) -> void:
	var microseconds = Time.get_ticks_usec()-start_microseconds
	var seconds = microseconds/10e5
	text = str(seconds)

func _ready() -> void:
	if !OS.is_debug_build():
		hide()
		queue_free()
