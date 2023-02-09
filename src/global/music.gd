extends Node2D


var tracks = {}

onready var music_player : AudioCrossfadePlayer = $music_player
onready var ambience_player : AudioCrossfadePlayer = $ambience_player

var ambience_track := ""
var music_track := ""
func _ready():
	for track in $tracks.get_children():
		tracks[track.name] = track

var main_song : AudioStreamPlayer

func play_ambience(track_name:String):
	if track_name != ambience_track:
		var track : AudioStreamPlayer = tracks[track_name] if track_name else null
		ambience_track = track_name
		ambience_player.crossfade_to(track.stream if track else null)
	

func play_music(track_name:String):
	if track_name != music_track:
		var track : AudioStreamPlayer = tracks[track_name] if track_name else null
		music_track = track_name
		music_player.crossfade_to(track.stream if track else null)
