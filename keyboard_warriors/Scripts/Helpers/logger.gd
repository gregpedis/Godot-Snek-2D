class_name Logger
extends Reference



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func log_debug(who, message):
	var f = _format_msg(who, message)
	print(f)
	
	
func log_error(who, message):
	var f = _format_msg(who, message)
	printerr(f)
	
	
func _format_msg(who, message):	
	var formatted = "DEBUG::{0}: {1}".format([who,message])
	return formatted
