extends Node2D

export var jump_energy_requirement := 1.0
export var max_energy := 4.0
export var energy_recovery_speed := 1.0

onready var energy_bar: Node = $bar
var dir = Vector2.RIGHT


func _ready() -> void:
	energy_bar.max_value = max_energy


func _physics_process(delta: float) -> void:
	var input = owner.input_state
	
#	if input.B.is_just_pressed() and owner.is_on_wall():
#		owner.jump_against_walls()
	if input.B.is_just_pressed() and input.dir and energy_bar.value >= jump_energy_requirement:
		energy_bar.value -= jump_energy_requirement
		owner.jump_in_dir()
	
	var delta_recovery = delta*energy_recovery_speed
	var missing_energy = (energy_bar.max_value-energy_bar.value)
	var empty_slots = floor(missing_energy/jump_energy_requirement)
	var greediness_penalty = (1.0+empty_slots/2.0)
	
#	energy_bar.value += delta_recovery/greediness_penalty
	energy_bar.value += delta_recovery
