extends Node
class_name RopeUtils

static func get_side_of_swing(Q:Vector2,O:Vector2,A:Vector2):
	var QO = O - Q
	var OA = A - O
	var QOxOA = QO.cross(OA)
	
	return sign(QOxOA)

static func is_swing_from_side_to_middle(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)

	
	return sign_A != 0 and sign_B == 0
static func is_swing_from_middle_to_side(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)

	
	return sign_A == 0 and sign_B != 0
static func get_side_of_full_swing(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)

	if sign_A == sign_B:
		return sign_A
	if sign_B == 0:
		return -sign_A
	return sign_B
	
static func get_current_side_of_swing(Q:Vector2, O:Vector2, P:Vector2):
	return sign((O-Q).cross(P-O))
	
	
static func pseudoangle(vec:Vector2, vec_base: Vector2 = Vector2.RIGHT):
	return vec_base.dot(vec)/sqrt(vec_base.length_squared()*vec.length_squared())




static func point_is_inside_triangle_inclusive(p:Vector2,a:Vector2,b:Vector2,c:Vector2):
	var result = (
		(p == a or p == b or p == c) or
		(triangle_has_area(a,b,c) and Geometry.point_is_inside_triangle(p,a,b,c)) or
		Geometry.get_closest_point_to_segment_2d(p,a,b) == p or
		Geometry.get_closest_point_to_segment_2d(p,b,c) == p or
		Geometry.get_closest_point_to_segment_2d(p,c,a) == p
	)
	return result

static func point_is_inside_triangle_inclusive_but_exclude_first_segment(p:Vector2,a:Vector2,b:Vector2,c:Vector2):
	var result = (
		(p == c) or
		(triangle_has_area(a,b,c) and Geometry.point_is_inside_triangle(p,a,b,c)) or
		Geometry.get_closest_point_to_segment_2d(p,b,c) == p or
		Geometry.get_closest_point_to_segment_2d(p,c,a) == p
	)
	return result

static func triangle_has_area(a:Vector2,b:Vector2,c:Vector2)->bool:
	return Geometry.get_closest_point_to_segment_uncapped_2d(a,b,c) != a



static func get_all_collider_points_inside_triangle(
	space:Physics2DDirectSpaceState, 
	O:Vector2,
	A:Vector2,
	B:Vector2, 
	physics_layers:=1, 
	exceptions:=[]
	):
	if !triangle_has_area(O,A,B):
		return []
	var points_inside_triangle = []
	
	var result = query_triangle(space, O, A, B, physics_layers, exceptions)
	var square_epsilon = 0.5
	for entry in result:
		var global_polygon_points = get_collider_global_points(entry)
		
		for point in global_polygon_points:
			var square_dist = point.distance_squared_to(O)
			if (
				square_dist<square_epsilon or 
				!point_is_inside_triangle_inclusive_but_exclude_first_segment(point,O,A,B)
			):
				continue
			
			points_inside_triangle.append(point)
	
	return points_inside_triangle


static func query_triangle(
	space:Physics2DDirectSpaceState, 
	O:Vector2,
	A:Vector2,
	B:Vector2, 
	physics_layers:=1, 
	exceptions:=[]
	):
	var query_shape := ConvexPolygonShape2D.new()
	query_shape.points = PoolVector2Array([O,A,B])
	var query = Physics2DShapeQueryParameters.new()
	query.collision_layer = physics_layers
	query.shape_rid = query_shape.get_rid()
	
	
	return space.intersect_shape(query)


static func get_collider_global_points(entry):
	var collider = entry.collider # The colliding object.
	print (entry)
	var collider_id = entry.collider_id # The colliding object's ID.
	var rid = entry.rid # The intersecting object's RID.
	var shape = entry.shape # The shape index of the colliding shape.
#	entry.collider.query(entry)
	var shape_rid = Physics2DServer.body_get_shape(rid, shape)
	var shape_data = Physics2DServer.shape_get_data(shape_rid)
	
	print(typeof(collider))
		
	var t := Transform2D.IDENTITY
	
	if collider is TileMap:
		var tilemap : TileMap = collider
		var cell: Vector2 = entry.metadata
		var quadrant = (cell / tilemap.cell_quadrant_size).floor()
		t = t.translated(quadrant*tilemap.cell_quadrant_size*tilemap.cell_size)
	
	
	t = collider.global_transform*t*(Physics2DServer.body_get_shape_transform(rid,shape))
	
	
	var points
	var shape_type := Physics2DServer.shape_get_type(shape_rid)
	
	match shape_type:
		Physics2DServer.SHAPE_RECTANGLE:
			points = get_rectangle_points(shape_data)
		Physics2DServer.SHAPE_CONCAVE_POLYGON, Physics2DServer.SHAPE_CONVEX_POLYGON:
			points = shape_data
	var xformed_shape_data = t.xform(points)
	print(xformed_shape_data)
	return xformed_shape_data

static func is_swing_from_side_to_side(Q:Vector2,O:Vector2,A:Vector2,B:Vector2):
	var QO = O - Q
	var OA = A - O
	var OB = B - O
	
	var QOxOA = QO.cross(OA)
	var QOxOB = QO.cross(OB)
	var sign_A = sign(QOxOA)
	var sign_B = sign(QOxOB)
	return sign_A != sign_B

static func get_rectangle_points(extents):
	return PoolVector2Array([-extents,Vector2(extents.x,-extents.y),extents,Vector2(-extents.x, extents.y)])
