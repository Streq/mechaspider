extends KinematicBody2D
class_name Character

signal dying()
signal dead()
signal pre_move()
signal post_move()


export (float, -1.0, 1.0, 2.0) var facing_dir := 1.0 setget set_facing_dir
func set_facing_dir(val):
	val = sign(val)
	if val == 0.0 or facing_dir == val:
		return
	facing_dir = val

	if !is_inside_tree():
		return
	pivot.scale.x = abs(pivot.scale.x)*facing_dir

export var gravity := Vector2()
export var damping := 0.0


onready var input_state := $"%input_state"
onready var animation_player := $"%animation_player"
onready var state_machine := $"%state_machine"
onready var pivot: Node2D = $"%pivot"


var velocity := Vector2()
var linear_velocity := Vector2() setget set_linear_velocity, get_linear_velocity

var previous_velocity := Vector2()
var dead = false

func _ready() -> void:
	state_machine.initialize()

func get_linear_velocity():
	return velocity

func set_linear_velocity(val:Vector2):
	velocity = val

func _physics_process(delta: float) -> void:
	previous_velocity = velocity
	
	emit_signal("pre_move")
	velocity = move_and_slide(velocity)
	emit_signal("post_move")
	
	velocity += gravity*delta
	velocity *= 1-delta*damping
	
	state_machine.physics_update(delta)
	animation_player.advance(delta)
	
	
	if dead:
		die()

func die():
	if state_machine.current.is_dead_state:
		return
	dead = true
	state_machine._change_state("air_dead")
	emit_signal("dying")
	emit_signal("dead")

func apply_central_impulse(impulse):
	velocity+=impulse
