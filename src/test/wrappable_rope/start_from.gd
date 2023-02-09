extends Node

export var vector_array : String


func _ready() -> void:
	vector_array = vector_array.replace("[(","")
	vector_array = vector_array.replace(")]","")
	vector_array = vector_array.replace("(","")
	vector_array = vector_array.replace(")","")
	var floats := vector_array.split_floats(",")
	if floats.size()>=2:
		var points = PoolVector2Array()
		for i in floats.size()/2:
			var point := Vector2(floats[i*2],floats[i*2+1])
			points.append(point)
		get_parent().line_points = points
		
