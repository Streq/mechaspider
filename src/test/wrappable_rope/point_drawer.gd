extends Node2D

export (DynamicFont) var debug_font

func _physics_process(delta: float) -> void:
	update()

func _draw():
	var _owner = get_parent().get_parent()
	var points = _owner.draw_collided_points
	
	var t = _owner.get_global_transform_with_canvas()
	var i = 0
	for point in points:
		draw_string(debug_font,t.xform(point),str(i))
		i+=1
