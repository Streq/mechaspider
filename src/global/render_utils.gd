class_name RenderUtils

static func draw_circle_slice(canvas_item:CanvasItem, center:Vector2, radius:float, angle_from:float, angle_to:float, color:Color):
	var nb_points = int(radius*2)
	var points_arc = PoolVector2Array()
	points_arc.push_back(Vector2.ZERO)
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	canvas_item.draw_colored_polygon(points_arc,color)
