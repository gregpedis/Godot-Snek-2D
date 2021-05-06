class_name Out
extends RichTextLabel

const COLOR_DEFAULT := "#838a99"
const COLOR_SUCCESS := "#49c92c"
const COLOR_FAILURE := "#af2a47"

var words := []
var word_idx := 0
var word := ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func initialize_stanza(words):
	self.words = words
	word_idx = 0
	
	var mutated_text = add_effect(add_color(words[0],COLOR_DEFAULT), "wave")

	for idx in range(1, words.size()):
		mutated_text += add_color(words[idx], COLOR_DEFAULT)
	
	self.bbcode_text = mutated_text
	#print(self.bbcode_text)
	parse_stanza()


func add_color(text, color):
	var format_values = {
		"color": color,
		"value": text,
		}
	var template = "[color={color}] {value} [/color]"
	return template.format(format_values)


func add_effect(text, effect, effect_props = []):
	var format_values = {
		"effect": effect,
		"value": text
	}
	var template = "[{effect}]{value}[/{effect}]"
	return template.format(format_values)	


func parse_stanza():
	pass
