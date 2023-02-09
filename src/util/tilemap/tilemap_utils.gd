class_name TilemapUtils

static func merge_navigation_polygons_into_one(tilemap:TileMap, block_size:=64) -> Dictionary:
	var islands = []
	var holes = []
	
	
	var rect = tilemap.get_used_rect()
	for j in range(rect.position.y, rect.end.y, block_size):
		for i in range(rect.position.x, rect.end.x, block_size):
			var merged = _generate_polygon_block(tilemap, i, j, block_size, block_size)
			islands.append_array(merged.islands)
			holes.append_array(merged.holes)
	var merge = GeometryUtils.merge_polys(islands)
	islands = merge.islands
	
	holes.append_array(merge.holes)
	
	return {islands=islands, holes=holes}





static func _generate_polygon_block(tilemap:TileMap,x0,y0,w,h):
	var rect = tilemap.get_used_rect()
	var tiles = tilemap.get_used_cells()
	var tile_size = tilemap.cell_size
	var islands = []
	var holes = []
	var tileset = tilemap.tile_set
	
	# por cada tile
	
	for y in range(y0,y0+h):
		for x in range(x0,x0+w):
			var tilemap_coord = Vector2(x,y)
			
			
#			update_polygon(navpoly,islands,holes)
			var tile_id = tilemap.get_cellv(tilemap_coord)
			if tile_id == TileMap.INVALID_CELL:
				continue
			
			var nav : NavigationPolygon 
			var offset : Vector2
			match tileset.tile_get_tile_mode(tile_id):
				TileSet.SINGLE_TILE:
					nav = tileset.tile_get_navigation_polygon(tile_id)
					offset = tileset.tile_get_navigation_polygon_offset(tile_id)
				TileSet.AUTO_TILE, TileSet.ATLAS_TILE:
					var subtile = tilemap.get_cell_autotile_coord(x,y)
					nav = tileset.autotile_get_navigation_polygon(tile_id, subtile)
					offset = Vector2()
			
			if !nav:
				continue
			var world_coord = tile_size*tilemap_coord+offset
			var outlines = nav.outlines
			# por cada outline en el tile
			for outline in outlines:
				var transform = Transform2D().translated(world_coord)*tilemap.transform
				var transformed_outline = transform.xform(outline)
				var taken = false
				# por cada isla
				if !islands.size():
					islands.append(transformed_outline)
					break
				for i in islands.size():
					if taken:
						break
					#tratar de mergear
					var merged_polygons = GeometryUtils.attempt_poly_merge(islands[i], transformed_outline)
					#si no colisionan seguir
					if !merged_polygons:
						continue
					for merged_polygon in merged_polygons:
						taken = true
						if !GeometryUtils.is_hole(merged_polygon):
							# si el resultado colisiona con otras islas, mergear
							islands[i] = merged_polygon
							var result = GeometryUtils.merge_polys(islands)
							islands = result.islands
							holes.append_array(result.holes)
						else:#if a hole
							holes.append(merged_polygon)
				if !taken:
					islands.append(transformed_outline)
	return {"islands":islands,"holes":holes}

static func fill_world_rect(
		tilemap: TileMap, 
		rect_in_global_coords: Rect2, 
		cell: int,  
		flip_x: bool = false, 
		flip_y: bool = false, 
		transpose: bool = false, 
		autotile_coord: Vector2 = Vector2( 0, 0 )
		):
	var local_start = tilemap.to_local(rect_in_global_coords.position)
	var tile_start = tilemap.world_to_map(local_start)
	
	var local_end = tilemap.to_local(rect_in_global_coords.end)
	var tile_end = tilemap.world_to_map(local_end)
	
	for i in range (tile_start.x, tile_end.x):
		for j in range(tile_start.y, tile_end.y):
			tilemap.set_cell(i,j,cell)
	
