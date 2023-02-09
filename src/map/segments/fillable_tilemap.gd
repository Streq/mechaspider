extends TileMap


func _ready() -> void:
	yield(owner,"ready")
	get_tree().call_group("tilemap_fill","fill_tilemap",self,0)
	
	for node in get_tree().get_nodes_in_group("fill_tilemap_polygon"):
		var polygon : CollisionPolygon2D = node
		var global_polygon = polygon.global_transform.xform(polygon.polygon)
		var rect_in_global_coords = GeometryUtils.get_polygon_bounding_rect(global_polygon)
		TilemapUtils.fill_world_rect(
			self, 
			rect_in_global_coords, 
			0
		)
		print(rect_in_global_coords)
		
	update_bitmask_region()
