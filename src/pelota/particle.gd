extends Sprite


export var velocity := Vector2()
export var drag := 2.0
var frames_visible = 0
func _process(delta: float) -> void:
	global_position += velocity*delta
	velocity *= (1.0-drag*delta)
	frames_visible += 1
	visible = (frames_visible%10)<5
	if velocity.length_squared()<50.0*50.0:
		queue_free()
