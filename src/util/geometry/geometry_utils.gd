extends Node
class_name GeometryUtils

#if you gonna use it a lot, you might prefer to cache the results of 
#get_triangulated and get_triangle_areas
#and call random_point_in_triangle(random_triangle_weighted_by_area(triangles,areas))
static func random_point_in_polygon(polygon: PoolVector2Array):
	var triangles = get_triangulated(polygon)
	return random_point_in_triangles(triangles, get_triangle_areas(triangles))

static func get_triangulated(polygon):
	var indexes = Geometry.triangulate_polygon(polygon)
	var triangles = PoolVector2Array()
	for i in indexes:
		triangles.append(polygon[i])
	return triangles

static func random_point_in_triangles(triangles: PoolVector2Array, weights: PoolRealArray):
	# if you don't weigh by area you get smaller triangles concentrating all them points!!!!!
	var i = random_weighted(weights)*3
#	var i = (randi()%(triangles.size()/3))*3
	return random_point_in_triangle(triangles[i], triangles[i+1], triangles[i+2])

#assumes triangles to be an array of triangles represented by triplets of points
#returns an array of areas, last element being the sum of all areas
static func get_triangle_areas(triangles:PoolVector2Array):
	var areas = PoolRealArray()
	var sum = 0.0
	for i in range(0, triangles.size(), 3):
		var area = get_triangle_area(triangles[i], triangles[i+1], triangles[i+2])
		sum += area
		areas.append(area)
	areas.append(sum)
	return areas

static func get_triangle_area(A,B,C):
	return abs(A.x*(B.y-C.y) + B.x*(C.y-A.y) + C.x*(A.y-B.y))/2

static func random_point_in_triangle(A:Vector2,B:Vector2,C:Vector2):
	var r1 = rand_range(0,1)
	var r2 = rand_range(0,1)
	if (r1 + r2 > 1):
		r1 = 1 - r1
		r2 = 1 - r2
	
	var a = 1 - r1 - r2
	var b = r1
	var c = r2

	return a*A + b*B + c*C

static func random_weighted(weights: PoolRealArray)->int:
	var sum = weights[-1]
	var r = rand_range(0, sum)
	var i = 0
	while i < weights.size()-1:
		r -= weights[i]
		if r <= 0:
			break
		i += 1
	return i


#returns array of PoolVector2Array if they overlap at all 
#otherwise returns empty array
static func attempt_poly_merge(a,b) -> Array:
	var merged_polygons = Geometry.merge_polygons_2d(a, b)
	var first = merged_polygons[0]
	#if at least one of the results is either of the input ones 
	#and there's two results
	#then we know the merge failed
	if merged_polygons.size()==2 and !is_hole(merged_polygons[0]) and !is_hole(merged_polygons[1]):
		return []
	return merged_polygons

static func is_hole(polygon:PoolVector2Array) -> bool:
	return Geometry.is_polygon_clockwise(polygon)


#merge several polygons
#TODO: fails on edge cases like islands within holes
#returns {islands:Array<PoolVector2Array>, holes:Array<PoolVector2Array>}
static func merge_polys(polys)-> Dictionary:
	OS.get_time()
	var result = {islands=polys,holes=[]}
	var i = 0
	var j = 0
	
	while i != polys.size():
		var a = polys[i]
		j = i+1
		while j != polys.size():
			var b = polys[j]
			var merges = attempt_poly_merge(a,b)
			if merges:
				var islands = []
				var holes = []
				for merge in merges:
					if is_hole(merge):
						holes.append(merge)
					else: 
						islands.append(merge)
				if islands.size() == 1:
					a = islands[0]
					polys.remove(j)
					j = i
				result.holes.append_array(holes)
#			print(polys.size())
			j += 1
		polys[i] = a
		i += 1
	return result

static func get_polygon_bounding_rect(polygon):
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	for point in polygon:
		min_x = min(point.x,min_x)
		max_x = max(point.x,max_x)
		min_y = min(point.y,min_y)
		max_y = max(point.y,max_y)
	return Rect2(Vector2(min_x,min_y), Vector2(max_x-min_x, max_y-min_y))
