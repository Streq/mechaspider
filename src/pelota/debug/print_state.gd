extends Label

onready var state_machine: Node = $"../state_machine"



func _process(delta: float) -> void:
	text = state_machine.current.name
