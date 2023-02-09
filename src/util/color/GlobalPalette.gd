extends Node
tool
onready var background: Node = $Background
onready var object: Node = $Object

onready var object_palettes := object.get_children()
onready var background_palettes := background.get_children()

onready var palettes = [background_palettes, object_palettes]

func change_palette(type: int, index: int, by: PoolColorArray) -> void:
	pass
func get_palette_material(type: int, index: int) -> Material:
	return palettes[type][index].material

func get_palette(type: int, index: int):
	return palettes[type][index]

var backup = [[],[]]

func backup():
	backup = [[],[]]
	for pal in background_palettes:
		backup[0].append(pal.palette)
	for pal in object_palettes:
		backup[1].append(pal.palette)
	pass

func reload():
	for i in background_palettes.size():
		background_palettes[i].palette = backup[0][i]
	for i in object_palettes.size():
		object_palettes[i].palette = backup[1][i]
	pass
func _ready() -> void:
	backup()
