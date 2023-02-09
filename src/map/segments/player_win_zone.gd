extends Area2D




func _on_player_win_zone_area_entered(area: Area2D) -> void:
	area.get_parent().despawn()
	owner.owner.win()
