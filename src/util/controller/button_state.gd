extends Reference
class_name ButtonState

var pressed := false setget set_pressed
var just_updated := false

func set_pressed(val:bool):
	just_updated = pressed!=val
	pressed = val

func is_just_pressed():
	return pressed and just_updated
func is_just_released():
	return !pressed and just_updated
func is_pressed():
	return pressed
func stale():
	just_updated = false
