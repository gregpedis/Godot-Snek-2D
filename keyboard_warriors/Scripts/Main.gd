class_name Main
extends Control

const Logger = preload("res://Scripts/Helpers/logger.gd")
const ProgressState = preload("res://Scripts/Models/ProgressState.gd")

signal mistake_spotted(idx)
signal mistake_corrected
signal text_changed(new_size)
signal word_completed
signal stanza_completed

onready var in_text = get_node("VSplit/Panel_In/In")
onready var out_text = get_node("VSplit/Panel_Out/Out")

var stanzas = [
	"Two things are infinite: the universe and human stupidity; and I'm not sure about the universe.",
	"I am so clever that sometimes I don't understand a single word of what I am saying.",
	"Do not go gentle into that good night...",
	"Yesterday is history, tomorrow is a mystery, today is a gift of God, which is why we call it the present.",
	"'The Answer to the Great Question... Of Life, the Universe and Everything... Is... Forty-two' said Deep Thought, with infinite majesty and calm.",
]

var stanza_idx := 0
var stanza := ""

var words := []
var word_idx := 0
var word := ""

var mistake_so_far := false

		
var progress : ProgressState
var logger : Logger
var rng : RandomNumberGenerator 

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	pick_new_stanza()
	
func initialize():
	logger = Logger.new()	
	progress = ProgressState.new()
	rng = RandomNumberGenerator.new()
	rng.randomize()


func pick_new_stanza():
	stanza_idx = rng.randi() % stanzas.size()
	stanza = stanzas[stanza_idx].strip_edges()
	words = stanza.split(" ")
	word_idx = 0
	word = words[word_idx]
	out_text.initialize_stanza(words)
	
	logger.log_debug("Main", "Stanza --> {0}".format([stanza]))
	logger.log_debug("Main", "Words  --> {w}".format({"w":words}))
	logger.log_debug("Main", "Word   --> {0}".format([word]))


func _on_In_text_changed(new_text:String):
	emit_signal("text_changed", new_text.length())
	if check_completed(new_text):
		if word_idx + 1 == words.size():
			pick_new_stanza()
		else:
			word_idx += 1
			word = words[word_idx]
			logger.log_debug("Main", "Word   --> {0}".format([word]))
	else:	
		check_mistake(new_text)


func check_mistake(new_text:String):
	if new_text: # just to avoid an debug message if the LineEdit is empty. OCD.
		logger.log_debug("Main","{0} ?== {1}".format([word,new_text]))
	var size_so_far = new_text.length()
	var matching = new_text == word.substr(0,size_so_far)
	if mistake_so_far:
		if matching: 
			emit_signal("mistake_corrected")
			mistake_so_far = false
			logger.log_error("Main", "Mistake was corrected.")
		return false
	else:
		if matching:
			return false
		else:
			emit_signal("mistake_spotted",new_text.length()-1)
			mistake_so_far = true
			logger.log_error("Main", "Mistake was spotted.")
			return true
	
	
func check_completed(new_text):
	var at_end = word_idx == words.size()-1
	var suffix = "" if at_end else " "
	var sig = "stanza_completed" if at_end else "word_completed"
	
	if new_text == word + suffix:
		logger.log_error("Main", "Word [{0}] completed.".format([word]))
		if at_end:
			logger.log_error("Main", "Stanza also completed.")
		emit_signal(sig)
		return true
	else:
		return false


func _on_Button_button_up():
	pick_new_stanza()
	emit_signal("stanza_completed")
