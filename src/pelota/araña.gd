extends KinematicBody2D

export var linear_velocity := Vector2()
export var gravity := 9.8

export var jump_speed := 250.0

func _physics_process(delta: float) -> void:
	linear_velocity.y += delta*gravity*25.0
	linear_velocity = move_and_slide(linear_velocity)

func apply_central_impulse(impulse):
	linear_velocity += impulse
func jump_against_walls():
	var collision_count = get_slide_count()
	for i in collision_count:
		var collision : KinematicCollision2D = owner.get_slide_collision(i)
		apply_central_impulse(collision.normal*jump_speed)
		return
signal farted()
signal bounced()

onready var input_state := $input_state
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var claw: Node2D = $claw



export var PARTICLE : PackedScene 
export var DEAD_PELOTA : PackedScene
var collision_velocity : Vector2 = Vector2.ZERO
var previous_linear_velocity : Vector2 = Vector2.ZERO
var previous_contacts := 0

#var jump_against_walls = false
#func jump_against_walls():
#	jump_against_walls = true
#	animation_player.play("jump")
#	pass

var jump_in_dir = false
func jump_in_dir():
	if !input_state.dir:
		return false
	var dir = input_state.dir
	call_deferred("fart_particles", dir)
	apply_central_impulse(dir.normalized()*jump_speed)
	animation_player.play("jump")
	return true

#
#func _integrate_forces(state: Physics2DDirectBodyState) -> void:
#	collision_velocity = Vector2.ZERO
#
#	var current_contacts = state.get_contact_count()
#	if current_contacts > 0:
#		var dv : Vector2 = state.linear_velocity - previous_linear_velocity
#		collision_velocity = dv
#
#	previous_linear_velocity = state.linear_velocity
#
#
#	if jump_against_walls:
#		var normal = Vector2()
#		for contact in state.get_contact_count():
#			var local_normal = state.get_contact_local_normal(contact)
#			normal+=local_normal
#		apply_central_impulse(normal.normalized()*jump_speed)
#	if jump_in_dir:
#
#		var dir = input_state.dir
#		call_deferred("fart_particles", dir)
#		apply_central_impulse(dir.normalized()*jump_speed)
#	jump_against_walls = false
#	jump_in_dir = false
#
#
#	if previous_contacts < current_contacts and collision_velocity.length_squared()>100*100:
#		emit_signal("bounced")
#
#	previous_contacts = state.get_contact_count()
#
#


func fart_particles(dir:Vector2):
	emit_signal("farted")
		
	for i in int(rand_range(5,9)):
		var particle = PARTICLE.instance()
		particle.material = material
		get_parent().add_child(particle)
		particle.global_position = self.global_position
		particle.velocity += linear_velocity
		particle.velocity -= dir.rotated(deg2rad(rand_range(-45,45)))*(500.0+rand_range(-100,100))
		
func despawn():
	queue_free()
	claw.queue_free()

func die():
	var dead_body = DEAD_PELOTA.instance()
	get_parent().add_child(dead_body)
	dead_body.position = self.position
	dead_body.material = self.material
	despawn()
	

func _on_hurtbox_area_entered(area: Area2D) -> void:
	die()
