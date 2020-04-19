extends Node2D

export var arrow_states: Dictionary = {
	"great": preload("res://Sprites/Arrows/sprite-arrow-great.png"),
	"bad": preload("res://Sprites/Arrows/sprite-arrow-bad.png"),
	"default": preload("res://Sprites/Arrows/sprite-arrow.png")
}

# Constants/Configurable variables
export var MIN_SCALE: int = .3
export var MAX_SCALE: int = 1.5
export var MOVEMENT_SPEED: int = 20
export var INITAL_STATE: String = "default"

# Setters/Getters
var current_state setget current_state_set, current_state_get
var player setget set_player, get_player

# Spawn Variables
onready var spawn_position = self.get_parent().global_position

# Class variables
var time = 0

onready var sprite = get_node("sprite-arrow")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.global_position = self.spawn_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Increment time counter
	time += delta
	
	# Set visible once scale can be set correctly
	self.visible = true
	self.update_relative_scale()
	
	# Move towards player
	self.update_position()

func update_position():
	var duration = 4
	var x = (time / duration)
	var percent = easeInSin(min(1, max(0, x)))
	self.global_position = self.get_parent().global_position.linear_interpolate(player.global_position, percent)

# Scale the Arrow size as it gets close to the player
func update_relative_scale():
	var dist1 = self.get_distance_to_player()
	var current_scale = lerp(MIN_SCALE, MAX_SCALE, min(1, 1 - dist1 / self.get_original_distance()))
	self.set_scale(Vector2.ONE * current_scale)

# Get the distance between this arrows spawn point and the current player position
func get_original_distance():
	if self.player:
		return self.spawn_position.distance_to(self.get_player().global_position)
	return INF

# Get the distance from the current position to the players current position
func get_distance_to_player():
	if self.player:
		return self.global_position.distance_to(self.get_player().global_position)
	return INF

# Get the current player
func get_player():
	return player

# Set the current player (Called by creator)
func set_player(set_player):
	player = set_player

# Set the state and update the arrow image
func current_state_set(new_state):
	if new_state != current_state:
		if new_state in arrow_states:
			self.sprite.set_texture(arrow_states[new_state])
			current_state = new_state

func current_state_get():
	return current_state

func easeInSin(x):
	return 0.2 * x + sin((x * PI) / 2)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
