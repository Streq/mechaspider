extends CanvasLayer

var app_state_node


func _on_AnimationPlayer_animation_finished(anim_name):
	exit()
func _input(event):
#	if event.is_action_pressed("A") or event.is_action_pressed("B"):
#		exit()
	pass
func exit():
	if is_instance_valid(app_state_node):
		app_state_node.switch("intro_game")
	
