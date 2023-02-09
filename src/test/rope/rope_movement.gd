extends Node2D
tool

onready var a: Node2D = $A
onready var b: Node2D = $B



func _draw() -> void:
	var A0 = to_local(a._0.global_position)
	var A1 = to_local(a._1.global_position)
	var B0 = to_local(b._0.global_position)
	var B1 = to_local(b._1.global_position)
	draw_line(A0,B0,Color.red,1.0)
	draw_line(A1,B1,Color.red,1.0)
	
	
func _process(delta: float) -> void:
	update()
