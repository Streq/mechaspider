extends Node2D


export var max_length := 200

var point_a : Node2D = null
var point_b : Node2D = null


func _physics_process(delta: float) -> void:
	point_a.global_position.distance_to(point_b.global_position)
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
