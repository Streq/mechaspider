extends Node2D

onready var bi_rope: Node2D = $bi_rope

onready var pin_claw: Node2D = $pin_claw
onready var pin_wearer: Node2D = $pin_wearer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	yield(owner,"ready")
	call_deferred("reparent")

func reparent():
	NodeUtils.reparent(pin_wearer, owner.wearer)
	NodeUtils.reparent(pin_claw, owner)
	NodeUtils.reparent(self, owner.wearer.get_parent())
