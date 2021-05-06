class_name In
extends LineEdit


const CLR_FAILURE = Color("#d60505")


# Called when the node enters the scene tree for the first time.
func _ready():
	self.grab_focus()
	self.text = ""


func _on_Main_word_completed():
	self.clear()


func _on_Main_stanza_completed():
	self.clear()


func _on_Main_mistake_spotted():
	self.add_color_override("font_color", CLR_FAILURE)


func _on_Main_mistake_corrected():
	self.set("custom_colors/font_color", null)
