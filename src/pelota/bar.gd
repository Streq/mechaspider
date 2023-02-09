extends Node
signal value_changed(value, max_value)

export var max_value := 5.0 setget set_max_value
export var value := 5.0 setget set_value

func set_value(val):
	value = clamp(val,0,max_value)
	emit_signal("value_changed", value, max_value)
func set_max_value(val):
	max_value = val
	set_value(value)
