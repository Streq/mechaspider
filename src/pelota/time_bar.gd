extends TextureProgress
signal full
onready var full_bar_marker: MarginContainer = $full_bar_marker

export var height := 32 setget set_height


func set_height(pixels: int):
	height = pixels
	update_height()


func update_height():
	var tex_progress: AtlasTexture = texture_progress
	tex_progress.region.size.y = height
	
	var tex_under: AtlasTexture = texture_under
	tex_under.region.size.y = height
	
	self.rect_size.y = height
	

func _on_value_changed(value, max_value) -> void:
	var was_full = self.value == self.max_value
	self.value = value
	var is_full = self.value == self.max_value
	if is_full and !was_full:
		emit_signal("full")
	
	full_bar_marker.visible = is_full
