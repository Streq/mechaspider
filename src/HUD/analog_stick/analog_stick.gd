extends Node2D

export var radius := 10.0

onready var head: Sprite = $rotate_transform/head
onready var stick: Sprite = $stick
onready var rotate_transform: Node2D = $rotate_transform



func update_position(vector:Vector2):
#	print(vector)
	var angle = vector.angle()+PI/2
	rotate_transform.rotation = angle
	rotate_transform.position = vector*radius
	rotate_transform.scale.y = lerp(1.0,0.65,vector.length())
	head.rotation = -angle
	stick.rotation = angle

