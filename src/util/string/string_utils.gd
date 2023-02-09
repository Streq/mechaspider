extends Node
class_name StringUtils

static func to_minutes(seconds: float):
	var mins = int(seconds)/60
	var secs = fmod(seconds,60.0)
	var text = "%02d" % mins + ":%05.2f" % secs
	return text

static func count_printable_characters(text:String):
	return text.length()-text.count(" ")-text.count("\n")
