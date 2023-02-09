extends Node
signal finished()
signal character()
export var time_per_char_in_seconds := 0.1

onready var label = get_parent()

func hide():
	label.hide()
	
func display(amount:=-1):
	label.show()
	var full_length = label.get_total_character_count()
	var current_length = label.visible_characters
	var remaining = (0 
		if current_length<0 
		else full_length-current_length
	) 
	if !remaining:
		return

	if amount >= 0:
		remaining = min(amount,remaining)
	
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

	for i in remaining-1:
		tween.tween_callback(self, "show_one_more_character")
		tween.tween_interval(time_per_char_in_seconds)
	tween.tween_callback(self, "show_one_more_character")
	tween.tween_callback(self,"emit_signal",["finished"])

func undisplay():
	label.visible_characters = 0
#	label.hide()

func show_one_more_character():
	label.visible_characters+=1
	emit_signal("character")
