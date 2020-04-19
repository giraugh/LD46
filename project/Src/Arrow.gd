extends Node2D

# Constants/Configurable variables
export var  MIN_SCALE = 1
export var  MAX_SCALE = 3
export var X_MOVEMENT_SPEED = 8
export var Y_MOVEMENT_SPEED = 4

# Spawn Variables
var spawn_position = null

# Class variables
var player = null
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.time = 0
	self.spawn_position = self.get_parent().global_position
	self.global_position = self.spawn_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	self.visible = true
	self.acc_toward_player()
	self.update_relative_scale()
	if self.get_distance_to_player() < Y_MOVEMENT_SPEED:
		queue_free()

func acc_toward_player():
	var player_x = global_position.x
	var player_y = global_position.y
	if self.player:
		player_x = self.get_player().global_position.x
		player_y = self.get_player().global_position.y

	var dist_x = pow(1/abs(player_x - self.global_position.x),2) * (-1 if player_x < self.global_position.x else 1)
	var dist_y = pow( 1.0/abs(player_y - self.global_position.y), 2) * (-1 if player_y <  self.global_position.y else 1)

	var new_x_pos = self.global_position.x + dist_x
	var new_y_pos = self.global_position.y + dist_y
	print_debug('[Arrow Movement For ', self, '] (current_pos) > (next_pos) ', global_position,' > ',Vector2(new_x_pos, new_y_pos))
	

	self.global_position = Vector2(new_x_pos, new_y_pos)


# Scale the Arrow size as it gets close to the player
func update_relative_scale():
	var dist1 = self.get_distance_to_player()
	var current_scale = (150.0/dist1)
	self.set_scale(Vector2(current_scale, current_scale))

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
	return self.player

# Set the current player (Called by creator)
func set_player(set_player):
	self.player =set_player

