class_name In
extends LineEdit

const Logger = preload("res://Scripts/Helpers/logger.gd")

const CLR_FAILURE = Color("#d60505")
const CLR_SUCCESS = Color("#ffffff")

var logger : Logger

# Called when the node enters the scene tree for the first time.
func _ready():
	logger = Logger.new()
	self.grab_focus()
	self.text = ""


func _on_Main_word_completed():
	self.clear()


func _on_Main_stanza_completed():
	self.clear()


func _on_Main_mistake_spotted(_idx:int):
	self.add_color_override("font_color", CLR_FAILURE)


func _on_Main_mistake_corrected():
	self.add_color_override("font_color", CLR_SUCCESS)
	#self.set("custom_colors/font_color", null)


func _on_In_focus_exited():
	logger.log_debug("In", "Focus lost!")
	grab_focus() # this appears to be NOT working.
	logger.log_debug("In", "Focus regained!")
