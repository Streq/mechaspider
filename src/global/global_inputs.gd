extends Node


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_pressed():
		match event.scancode:
			KEY_R:
				if OS.is_debug_build():
					print("restarting")
					for i in 10:
						print()
					
					get_tree().reload_current_scene()
			KEY_F:
				if !OS.has_feature("playjam"):
					OS.window_fullscreen = !OS.window_fullscreen
		
