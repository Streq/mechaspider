extends Node2D
tool
onready var _0: Position2D = $"0"
onready var _1: Position2D = $"1"
export var color := Color.blue

func _draw() -> void:
	draw_line(_0.position,_1.position,color,1.0)
	
	
func _process(delta: float) -> void:
	update()
