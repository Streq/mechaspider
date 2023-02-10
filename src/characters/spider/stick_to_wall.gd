extends Node
export var enabled:=false


func trigger() -> void:
	if enabled:
		owner.velocity = Vector2.DOWN.rotated(owner.pivot.rotation).snapped(Vector2(1,1))
		owner.move_and_slide(owner.velocity*60)
