extends Node
class_name AudioCrossfadePlayer

export var bus: String = "Master"

# References to the nodes in our scene
onready var _anim_player := $AnimationPlayer
onready var _track_1 := $Track1
onready var _track_2 := $Track2

func _ready():
	_track_1.bus = bus
	_track_2.bus = bus

# crossfades to a new audio stream
func crossfade_to(audio_stream: AudioStream) -> void:
	
	# If both tracks are playing, we're calling the function in the middle of a fade.
	# We return early to avoid jumps in the sound.
	if _track_1.playing and _track_2.playing:
		return

	# The `playing` property of the stream players tells us which track is active. 
	# If it's track two, we fade to track one, and vice-versa.
	if _track_2.playing:
		if !audio_stream:
			_anim_player.play("FadeOutOfTrack2")
		else:
			_track_1.stream = audio_stream
			_track_1.play()
			_anim_player.play("FadeToTrack1")
	else:
		if !audio_stream:
			_anim_player.play("FadeOutOfTrack1")
		else:
			_track_2.stream = audio_stream
			_track_2.play()
			_anim_player.play("FadeToTrack2")

func change_no_crossfade(audio_stream: AudioStream) -> void:
	crossfade_to(audio_stream)
	_anim_player.advance(_anim_player.current_animation_length)
