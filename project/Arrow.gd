extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MIN_SCALE = 1
const MAX_SCALE = 3

var player = null
var time = 0
var initial_pos = null
export var speed = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	set_position(Vector2(0, speed * time))
	initial_pos = global_position

#alled every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	self.set_relative_scale()
	set_position(Vector2(0, speed * time))
	if self.get_distance_to_player() < self.speed:
		queue_free()

func set_relative_scale():
	var dist1 = self.get_distance_to_player()
	var dist2 = self.get_original_distance()
	var current_scale =  (1 - dist1 / dist2) * MAX_SCALE
	self.set_scale(Vector2(current_scale, current_scale))
	
func get_original_distance():
	if self.player:
		return self.initial_pos.distance_to(self.get_player().global_position)
	return INF
	
func get_distance_to_player():
	if self.player:
		return self.global_position.distance_to(self.get_player().global_position)
	return INF
	
func get_player():
	return self.player

func set_player(player):
	self.player = player
	print(self.player)
