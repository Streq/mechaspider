extends TileMap

#{collider:TileMap2:[TileMap:1722], collider_id:1722, metadata:(37, 16), rid:[RID], shape:5}
func query(entry):
	print(entry)
	print(tile_set.tile_get_shapes(0)[entry.shape])
	var cell = get_cell(entry.metadata.x, entry.metadata.y)
	var autotile_coord = get_cell_autotile_coord(entry.metadata.x, entry.metadata.y)
	
	print(autotile_coord)
	var shape_rid = Physics2DServer.body_get_shape(entry.rid,entry.shape)
	print(shape_rid)
	print(Physics2DServer.shape_get_data(shape_rid))
	var shape = tile_set.tile_get_shapes(cell)[entry.shape]
	print(shape)
	pass
