extends Node2D

onready var camera_2d: Camera2D = $Camera2D
onready var lose_label: Label = $"%lose_label"
onready var win_label: Label = $"%win_label"
onready var music: AudioStreamPlayer = $music
onready var intro_music: AudioStreamPlayer = $intro_music
onready var game_over: AudioStreamPlayer = $game_over

export var camera_speed := 15.0

func _physics_process(delta: float) -> void:
	camera_2d.position.y-=camera_speed*delta


func win():
	win_label.show()
	yield(get_tree().create_timer(2.0),"timeout")
	Playjam.win()
	
func lose():
	lose_label.show()
	game_over.play()
	music.stop()
	yield(game_over,"finished")
	Playjam.lose()
	


func _on_player_lose_zone_area_entered(area: Area2D) -> void:
	lose()


func _on_player_win_zone_area_entered(area: Area2D) -> void:
	win()

func play_music():
	intro_music.stop()
	music.play()
