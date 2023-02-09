extends Node2D
var input_state
func _ready():
	input_state = get_parent().get_node("%input_state")

func _physics_process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("player")
	if !players:
		return
	var player = players[0]
	input_state.dir = global_position.direction_to(player.global_position)
