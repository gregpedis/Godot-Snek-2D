class_name Apple
extends Area2D

signal apple_eaten()

export (Vector2) var collider_size;
onready var screen_size = get_viewport_rect().size
onready var margin_size = collider_size / 2
onready var indexes = (screen_size - collider_size)/collider_size
onready var properly_placed : bool = true

onready var snake = get_node("/root/Main/Snake")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print(snake)
	rng.randomize()
	$Sprite.playing = true
	move_to_new_position()
	show_debug_messages()

func show_debug_messages():
	print("DEBUG::APPLE: Screen size = {0}".format([screen_size]))
	print("DEBUG::APPLE: Collider size = {0}".format([collider_size]))
	print("DEBUG::APPLE: Margin size = {0}".format([margin_size]))
	print("DEBUG::APPLE: Indexes = {0}".format([indexes]))

# tries to move the apple to a new position.
func move_to_new_position():
	while true:
		var x_pos = rng.randi_range(0, indexes.x)
		var y_pos = rng.randi_range(0, indexes.y)  
		var new_pos = Vector2(x_pos, y_pos) * collider_size + margin_size

		if position_is_valid(new_pos):
			self.position = new_pos
			break
		else:
			print("DEBUG::APPLE: Can't go to position {0}, taken by snake_block".format([new_pos]))		
	
# tries to find if a position is occupied by a snake block.			
func position_is_valid(new_pos):
	if new_pos == snake.position:
		return false
	for sb in snake.snake_blocks:
		if new_pos == sb.position:
			return false
	return true

# Collided with snake.
func _on_Apple_body_entered(body):
	if body.name == "Snake":
		print("DEBUG::APPLE: Hey i was eaten by Snake-chan")
		emit_signal("apple_eaten")
		move_to_new_position()

