extends AudioStreamPlayer2D

const EPSILON = 0.0001

func _physics_process(delta: float) -> void:
	var relative_velocity = owner.velocity-owner.wearer.linear_velocity
	var speed = relative_velocity.length()
	self.pitch_scale = max(EPSILON, speed/200.0)
	self.volume_db = clamp((-800+speed)/10.0,-80,0)
	
func play(from_position:float = 0.0):
	if !playing:
		.play(from_position)
