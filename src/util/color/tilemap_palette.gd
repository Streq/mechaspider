extends Node
tool
func _ready() -> void:
	for child in get_children():
		var tile_set = get_parent().tile_set
		var tile_id = tile_set.find_tile_by_name(child.name)
		
#		var palette_material = child.material
		child.connect("updated", self, "update_palette", [tile_id])
		update_palette(child.palette_material, tile_id)

func update_palette(palette_material, tile_id):
	var tile_set = get_parent().tile_set
	tile_set.tile_set_material(tile_id, palette_material)
