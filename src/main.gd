extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	print(Geometry.line_intersects_line_2d(Vector2(0,0),Vector2(1,0), Vector2(2,0), Vector2(2,0)))
#	print(Geometry.segment_intersects_segment_2d(Vector2(0,0),Vector2(2,0), Vector2(0,0), Vector2(2,0)))
#	var a = [1,2,3]
#	a.insert(a.size()-1,4)
#	print(a)
#	var r = PoolRealArray([1,2,3])
#	r.insert(0,4)
#	print(r)


#	var array = []
#	append_something(array,"hola")
#	print(array)
	
#	var map = {
#		"s":PoolVector2Array()
#	}
#	map.s.append(Vector2(1,1))
#
#	var arr = [PoolVector2Array()]
#	arr[0].append(Vector2())
#
#
#	print(map)
#	print(arr)
	var arr = [1,2,3]
	var e = 4
	
	insert(arr,1,e)
	insert(arr,-1,e)

	print(arr)
	
func append_something(array, something):
	array.append(something)



func insert_begin(arr:Array, val):
	arr.insert(0, val)
	
func insert_second(arr:Array, val):
	arr.insert(1, val)
func insert(arr:Array, increment, val):
	arr.insert(posmod(increment,arr.size()), val)
