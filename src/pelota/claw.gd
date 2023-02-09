extends KinematicBody2D

"""
Una garra tiene los siguientes estados:
	-idle (invisible, no hace nada)
	-disparando (visible, alejandose del jugador, lista para agarrar)
	-agarrando (visible, estatica, lista para soltar, atrayendo al jugador)
	-retrayendo (volviendo al jugador, inutilizable hasta regresar)
"""
export var throw_drag := 2.0
export var retrieve_drag := 2.0
export var throw_speed := 750.0
export var retrieve_acceleration := 1000.0
export var throw_decceleration := 1000.0
export var pull_force := 1000.0

export var distance_from_wearer := 16.0

var velocity := Vector2()

onready var wearer_detect_area: Area2D = $wearer_detect_area
onready var grab_area: Area2D = $grab_area
onready var wearer := get_parent() 
onready var state_machine: Node = $state_machine

onready var animation_player: AnimationPlayer = $AnimationPlayer
func _ready():
	state_machine.initialize()


func _physics_process(delta: float) -> void:
	animation_player.advance(delta)
	state_machine.physics_update(delta)
	
func shoot():
	pass

func moving_away_from_wearer():
	var relative_velocity : Vector2 = velocity - wearer.linear_velocity
	var distance_from_wearer : Vector2 = global_position - wearer.global_position
	
#	print(distance_from_wearer)
#	print(relative_velocity.dot(distance_from_wearer))
#	print(relative_velocity.project(distance_from_wearer).length_squared())
#
#	if (!(
#		!distance_from_wearer or
#		(
#			relative_velocity.dot(distance_from_wearer)>0 and
#			relative_velocity.project(distance_from_wearer).length_squared()
#		)
#	)):
#		breakpoint
	
	
	return (
		!distance_from_wearer or
		(
			relative_velocity.dot(distance_from_wearer)>0 and
			relative_velocity.project(distance_from_wearer).length_squared()
		)
	)
	
