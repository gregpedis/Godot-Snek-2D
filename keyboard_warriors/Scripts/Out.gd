class_name Out
extends RichTextLabel

const Logger = preload("res://Scripts/Helpers/logger.gd")
const BBCodeFormatter = preload("res://Scripts/Helpers/bbcode_formatter.gd")
const OutputState  = preload("res://Scripts/Models/OutputState.gd")

var logger : Logger
var formatter : BBCodeFormatter
var _state : OutputState


# Called when the node enters the scene tree for the first time.
func _ready():
	logger = Logger.new()
	formatter = BBCodeFormatter.new()
	_state = OutputState.new()


func initialize_stanza(new_words):
	_state.reset(new_words)
	render_output()
	
	
func render_output():
	var mutated_text = formatter.format_text(_state)
	self.bbcode_text = mutated_text
	logger.log_debug("Out", mutated_text)


func _on_Main_text_changed(new_size):
	_state.char_idx = new_size-1
	render_output()


func _on_Main_word_completed():
	_state.move_word()
	render_output()


func _on_Main_stanza_completed():
	pass


func _on_Main_mistake_spotted(idx):
	_state.mistake_idx = idx
	render_output()


func _on_Main_mistake_corrected():
	_state.mistake_idx = -1
	render_output()	
