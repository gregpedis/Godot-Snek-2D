class_name BBCodeFormatter
extends Reference

const OutputState = preload("res://Scripts/Models/OutputState.gd")
const Logger = preload("res://Scripts/Helpers/logger.gd")

# before current
const COLOR_WORDS_COMPLETED := "#34961e"
# after current
const COLOR_WORDS_REMAINING := "#838a99"
# current
const COLOR_WORD_CORRECT := "#49c92c"
const COLOR_WORD_WRONG := "#b04c4c"
const COLOR_WORD_REMAINING := "#dbdbdb"


func format_text(state : OutputState):
	var mutated_text := ""
	
	# before current word
	mutated_text += _format_completed_words(state)
	# current word
	mutated_text += _format_current_word(state)
	# after current_word
	mutated_text += _format_remaining_words(state)
	
	return mutated_text


func _join_array_slice(string_array:PoolStringArray, from:int, to:int):
	var subarray = (string_array as Array).slice(from, to, 1, false)
	var joined = (subarray as PoolStringArray).join(" ")
	return joined


func _format_completed_words(state: OutputState):
	var completed_text := ""
	
	if state.word_idx > 0:
		var text_completed = _join_array_slice(state.words, 0, state.word_idx-1)
		completed_text = _add_color(text_completed, COLOR_WORDS_COMPLETED)
		
	return completed_text


func _format_remaining_words(state: OutputState):
	var remaining_text := ""
	
	if state.word_idx < state.words.size()-1:
		var remaining = _join_array_slice(state.words, state.word_idx+1, state.words.size()-1)
		remaining_text = _add_color(remaining, COLOR_WORDS_REMAINING)
	
	return " " + remaining_text


func _format_current_word(state: OutputState):
	# current word
	var curr_word_correct := ""
	var curr_word_wrong := ""
	var curr_word_remaining := ""
	var empty_if_needed = " " if state.word_idx > 0 else ""
	
	var fixed_curr_idx = clamp(state.char_idx, -1, state.word.length()-1)
	var fixed_mistake_idx = clamp(state.mistake_idx, -1, state.word.length())
	
	if fixed_curr_idx > -1:
		if state.has_mistake():
			curr_word_correct = state.word.substr(0, fixed_mistake_idx)
			curr_word_wrong = state.word.substr(fixed_mistake_idx, fixed_curr_idx-fixed_mistake_idx+1)
			curr_word_remaining = state.word.substr(fixed_curr_idx+1)
			printerr(curr_word_correct)
			printerr(curr_word_wrong)
		else:
			curr_word_correct = state.word.substr(0, fixed_curr_idx+1)
			curr_word_remaining = state.word.substr(fixed_curr_idx+1)
	else:
		curr_word_remaining = state.word
		
	var part1 = _add_color(curr_word_correct, COLOR_WORD_CORRECT)
	var part2 = _add_effect(_add_color(curr_word_wrong, COLOR_WORD_WRONG),"shake", {"rate":20, "level":20})
	var part3 = _add_color(curr_word_remaining, COLOR_WORD_REMAINING)
	
	var curr
	var current_text = _add_effect(part1 + part2 + part3,"wave", {"amp":20, "freq":5})
	
	return empty_if_needed + current_text


func _add_color(text, color):
	var format_values = {
		"color": color,
		"value": text,
		}
	var template = "[color={color}]{value}[/color]"
	return template.format(format_values)


func _add_effect(text, effect, params = {}):
	var customization : PoolStringArray = []
	for key in params:
		var new_property = "{0}={1}".format([key, params[key]])
		customization.append(new_property)
	
	var format_values = {
		"effect": effect,
		"value": text,
		"customization" : customization.join(" ")
	}
	var template = "[{effect} {customization}]{value}[/{effect}]"
	return template.format(format_values)	
