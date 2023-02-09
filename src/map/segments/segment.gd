extends Node2D

signal init()

onready var gap: Node2D = $"%gap"

export var height := 270.0

export var leftmost_gap_point := -320
export var rightmost_gap_point := 320


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gap.position.x += stepify(rand_range(leftmost_gap_point,rightmost_gap_point),16.0)


func init():
	emit_signal("init")
