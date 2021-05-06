class_name Snake
extends KinematicBody2D

export (PackedScene) var SnakeBlock
export (float) var distance_moved

const LEFT  = Vector2.LEFT
const RIGHT  = Vector2.RIGHT
const UP  = Vector2.UP
const DOWN  = Vector2.DOWN

var curr_dir := LEFT
var last_input := LEFT

var snake_blocks:= []
var just_eaten:=false

onready var root_node = get_tree().get_root()
onready var screen_size = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.playing = true
	set_initial_body()
	show_debug_messages()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_input()


func show_debug_messages():
	print("DEBUG::SNAKE: distance_moved = {0}".format([distance_moved]))
	print("DEBUG::SNAKE: viewport_rect_size = {0}".format([screen_size]))


func set_initial_body():
	var sb1 = SnakeBlock.instance()
	var sb2 = SnakeBlock.instance()
	sb1.position = self.position + RIGHT * distance_moved
	sb2.position = self.position + RIGHT * distance_moved * 2
	snake_blocks = [sb1, sb2]
	root_node.call_deferred("add_child", sb1)
	root_node.call_deferred("add_child", sb2)
	
	print("DEBUG::SNAKE: Snakeblock1 position = {0}".format([sb1.position]))
	print("DEBUG::SNAKE: Snakeblock2 position = {0}".format([sb2.position]))
	
# gets and sets the user input.	
func get_input():
	if Input.is_key_pressed(KEY_R):
		restart()
		return
	if Input.is_action_pressed("move_left"):
		last_input = LEFT
	elif Input.is_action_pressed("move_right"):
		last_input = RIGHT
	elif Input.is_action_pressed("move_up"):
		last_input = UP
	elif Input.is_action_pressed("move_down"):
		last_input = DOWN


# called every time a move should be made, signaled by a timer.
func _on_SnakeTimer_timeout():
	set_direction()
	move_tail()  # this should happen before moving the head.
	move_head()
	check_if_killed()

	
# sets a new direction if permitted.
func set_direction():
	if are_perpendicular(curr_dir, last_input):
		curr_dir = last_input	

# moves the last block to the previous head's position 
# or spawns a new snake_block if an apple was eaten in the last timer timeout,
# while also shifting the snake blocks list (very inefficient).
func move_tail():
	if just_eaten:
		var new_block = SnakeBlock.instance()
		new_block.position = self.position
		snake_blocks.push_front(new_block)
		root_node.call_deferred("add_child", new_block)
		just_eaten=false
	else:
		var last = snake_blocks[-1]
		last.position = self.position
		snake_blocks.remove(snake_blocks.size()-1)
		snake_blocks.push_front(last)

# move head to the new position.
func move_head():
	self.position += curr_dir * distance_moved	
		
func check_if_killed():
	var out_less = position.x < 0 || position.y <0
	var out_more = position.x > screen_size.x || position.y > screen_size.y
	if out_less || out_more:
		restart()
		return
	for sb in snake_blocks:
		if self.position == sb.position:
			restart()
			return
	
func restart():
	var result = get_tree().reload_current_scene()
	print("DEBUG:: SNAKE: Tried to restart scene with status: {0}".format([result]))
	
# checks if a vector is horizontal.
func is_h(v:Vector2) -> bool:
	return v == LEFT || v == RIGHT

# checks if a vector is vertical.
func is_v(v:Vector2) -> bool:
	return not is_h(v)

# checks if vector x1 and x2 are perpendicular.
func are_perpendicular(x1,x2) -> bool:
	return (is_h(x1) && is_v(x2)) || (is_h(x2) && is_v(x1))
	

# this serves the purpose of spawning an additional snake_block in move_tail
func _on_Apple_apple_eaten():
	just_eaten = true
