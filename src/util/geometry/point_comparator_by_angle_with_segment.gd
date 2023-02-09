class_name PointComparatorByAngleWithSegment
var O : Vector2
var E : Vector2
var OE : Vector2

func _init(origin:Vector2,end:Vector2):
	self.O = origin
	self.E = end
	self.OE = end-origin

func compare_points_asc(P1:Vector2,P2:Vector2):
#	print("PSEUDOANGLES")
#	print("P1:", P1," angle:%.16f"%pseudoangle(P1-O,OE)," distance:",P1.distance_squared_to(O))
#	print("P2:", P2," angle:%.16f"%pseudoangle(P2-O,OE)," distance:",P2.distance_squared_to(O))
	var pa1 = pseudoangle(P1-O,OE)
	var pa2 = pseudoangle(P2-O,OE)
	if is_equal_approx(pa1,pa2):
		if P1.distance_squared_to(O)<=P2.distance_squared_to(O):
			return true
		return false
	if pa1 > pa2:
		return true
	return false

static func pseudoangle(vec:Vector2, vec_base: Vector2 = Vector2.RIGHT):
	return vec_base.dot(vec)/sqrt(vec_base.length_squared()*vec.length_squared())
