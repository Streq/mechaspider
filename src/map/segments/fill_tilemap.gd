extends Node2D

func _ready() -> void:
	add_to_group("tilemap_fill")
#	fill_tilemap(tile_map, 0)
#	TilemapUtils.fill_world_rect(tile_map, 
#		Rect2(Vector2(),Vector2(1000,1000)), 
#		0)

func fill_tilemap(
		tilemap: TileMap,
		cell: int,  
		flip_x: bool = false, 
		flip_y: bool = false, 
		transpose: bool = false, 
		autotile_coord: Vector2 = Vector2( 0, 0 )
		):
	for child in get_children():
		var col_shape : CollisionShape2D = child
		var rect_shape : RectangleShape2D = col_shape.shape
		var extents = rect_shape.extents * col_shape.global_scale
		extents.x = abs(extents.x)
		extents.y = abs(extents.y)
		var rect_in_global_coords = Rect2(col_shape.global_position-extents,extents*2)
		TilemapUtils.fill_world_rect(
			tilemap, 
			rect_in_global_coords, 
			cell,  
			flip_x, 
			flip_y, 
			transpose, 
			autotile_coord
		)
	tilemap.update_bitmask_region()
