class_name OutputState
extends Reference

var words : PoolStringArray
var word_idx : int
var word : String setget ,_get_word
var char_idx : int
var mistake_idx : int
	
func _init():
	words = []
	word_idx = 0
	char_idx = -1
	mistake_idx = -1
	
func _get_word():
	return words[word_idx]	
	
func has_mistake():
	return self.mistake_idx > -1
	
func move_word():
	word_idx += 1
	char_idx = -1
	mistake_idx = -1

func reset(new_words):
	words = new_words
	word_idx = 0
	char_idx = -1
	mistake_idx = -1

func show():
	printerr("Words: {0}".format([self.words]))
	printerr("Word: {0}".format([self.word]))
	printerr("Word Index: {0}".format([self.word_idx]))
	printerr("Char Index: {0}".format([self.char_idx]))
	printerr("Mistake Index: {0}".format([self.mistake_idx]))
