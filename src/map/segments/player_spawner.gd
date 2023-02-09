extends Node2D

onready var controller: Node = $controller
onready var player_zone: Area2D = $player_zone
onready var camera_2d: Camera2D = $Camera2D
export var PELOTA : PackedScene
export var spawn_velocity := Vector2(500,-20)

func _ready() -> void:
	controller.set_physics_process(false)

func _on_segment_init() -> void:
	yield(get_tree().create_timer(4.5),"timeout")
	var pelota = PELOTA.instance()
	pelota.position = owner.owner.to_local(global_position)
	owner.owner.add_child(pelota)
	NodeUtils.reparent(controller, pelota)
	NodeUtils.reparent(player_zone, pelota)
	NodeUtils.reparent(camera_2d, pelota)
	pelota.linear_velocity = spawn_velocity
	pelota.previous_contacts = 0
	controller.set_physics_process(true)
	owner.owner.play_music()
