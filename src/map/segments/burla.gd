extends Node2D


onready var label: Label = $label

onready var player_detector: Area2D = $player_detector

var player_fell_for_it = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(owner,"ready")
#	print(global_scale)
	scale.x = get_parent().scale.x


func _on_camera_detector_area_entered(area: Area2D) -> void:
	label.visible = !player_detector.get_overlapping_areas().empty()
	show()
