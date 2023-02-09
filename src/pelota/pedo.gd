extends AudioStreamPlayer2D


export (Array, AudioStream) var streams := []

func play(from_position:float = 0.0):
	stream = streams[randi()%streams.size()]
	.play(from_position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
