extends Node2D


export (Array, Array, PackedScene) var segments
export (Array, int) var segment_counts 

var accumulated_height = 0
onready var camera_2d: Camera2D = $"../Camera2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for difficulty in segments.size():
		for i in segment_counts[difficulty]:
			var segment = segments[difficulty][randi()%segments[difficulty].size()].instance()
			add_segment(segment)
#	add_segment(get_start_segment())
#
#	for difficulty in range(1,2):
#		for i in 4:
##		for i in 0:
#			var segment = segments[difficulty][randi()%segments[difficulty].size()].instance()
#			add_segment(segment)
#	for difficulty in range(2,segments.size()-1):
#		for i in 3:
##		for i in 0:
#			var segment = segments[difficulty][randi()%segments[difficulty].size()].instance()
#			add_segment(segment)
#
#	add_segment(get_finish_segment())
	camera_2d.limit_top = stepify(accumulated_height,16)

func get_start_segment():
	return segments[0][randi()%segments[0].size()].instance()

func get_finish_segment():
	return segments[-1][randi()%segments[-1].size()].instance()


func add_segment(segment):
	add_child(segment)
	accumulated_height -= segment.height
	segment.position.y = stepify(accumulated_height,16)
	segment.owner = owner
	segment.init()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
