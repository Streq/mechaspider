extends Node2D

export var _velocity := Vector2()
export var _gravity := 200.0

var velocity := Vector2()
var gravity := 0.0

func _ready() -> void:
	yield(get_tree().create_timer(0.7),"timeout")
	velocity = _velocity
	gravity = _gravity
func _physics_process(delta: float) -> void:
	position += velocity*delta
	velocity.y += gravity*delta
