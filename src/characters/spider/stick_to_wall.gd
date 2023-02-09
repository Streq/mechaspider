extends Node
export var enabled:=false
func _physics_process(delta: float) -> void:
	if enabled:
		owner.velocity = Vector2.DOWN.rotated(owner.pivot.rotation)*100
