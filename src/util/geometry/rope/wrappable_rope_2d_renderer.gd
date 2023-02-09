extends Node2D
export (DynamicFont) var debug_font

export var camera_path : NodePath
onready var camera : Camera2D = get_node(camera_path) if has_node(camera_path) else null

export var rope_path : NodePath
onready var rope : Node2D = get_node(rope_path) if has_node(rope_path) else null


var check_triangles = []
var split_points = []
var join_points = []
var scanned_points = []
var rope_points = PoolVector2Array([Vector2(),Vector2()])

func _on_bi_rope_check(O, A, B) -> void:
	check_triangles.append(PoolVector2Array([O,A,B]))

func _on_bi_rope_join(point) -> void:
	join_points.append(point)


func _on_bi_rope_scanned_points(points) -> void:
	scanned_points.append(points)

func _on_bi_rope_split(point) -> void:
	split_points.append(point)

func _on_bi_rope_step_begin() -> void:
	check_triangles = []
	split_points = []
	join_points = []
	scanned_points = []

func _on_bi_rope_step_end() -> void:
	pass # Replace with function body.
	
	
func _process(delta: float) -> void:
	update()

func _draw() -> void:
	var t = rope.get_global_transform_with_canvas()
	
	for triangle in check_triangles:
		var draw_triangle = t.xform(triangle)
		draw_triangle.append(draw_triangle[0])
		if !Geometry.triangulate_polygon(draw_triangle).empty():
			draw_colored_polygon(draw_triangle,Color.yellow*0.1)
		draw_polyline(draw_triangle,Color.yellow*0.75)

#	var i := 0
#	for draw_triangle in draw_triangles:
#		if !Geometry.triangulate_polygon(draw_triangle).empty():
#			draw_colored_polygon(draw_triangle,Color.green.linear_interpolate(Color.cyan,i*0.5)*0.25)
#		draw_triangle.append(draw_triangle[0])
#		draw_polyline(draw_triangle,Color.red*0.75)
#		i+=1
	
	var zoom = Vector2(1,1)
	
	if camera:
		zoom = camera.zoom
	var rect_size = Vector2(10,10)*zoom
	var rect_offset = -rect_size*0.5
	for point in split_points:
		draw_rect(t.xform(Rect2(point+rect_offset,rect_size)),Color(1.0,0.0,0.0,0.5))
	for point in join_points:
		draw_rect(t.xform(Rect2(point+rect_offset,rect_size)),Color(0.0,0.0,1.0,0.5))
		
	draw_polyline(t.xform(rope_points),Color.green)
	
	for points in scanned_points:
		var i = 0
		for point in points:
			draw_string(debug_font,t.xform(point),str(i))
			i+=1

	pass


func _on_bi_rope_updated(points) -> void:
	rope_points = points



func _physics_process(delta: float) -> void:
	update()
