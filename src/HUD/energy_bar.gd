extends VBoxContainer

export var BAR_SEGMENT : PackedScene

onready var jump: Node2D = $"../../../jump"

var segments = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bar = jump.energy_bar
	var jump_energy = jump.jump_energy_requirement
	var max_energy = bar.max_value
	var segment_count = int(max_energy/jump_energy)
	var segment_height = 32/segment_count
	for i in range(segment_count-1, -1, -1):
		var segment: TextureProgress = BAR_SEGMENT.instance()
		segment.max_value = jump_energy*(i+1)
		segment.min_value = jump_energy*i
		add_child(segment)
		segment.height = segment_height
		segments.append(segment)
		bar.connect("value_changed", segment, "_on_value_changed")
	pass # Replace with function body.
	
	
