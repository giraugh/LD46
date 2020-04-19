extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var target_scale = Vector2(0,0)
var grow_delay = 3.0
# Called when the node enters the scene tree for the first time.
func _ready():
	target_scale = get_scale()
	set_scale(Vector2(0,0))

var global_time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_time += delta
	var current_scale = get_scale()
	set_scale((target_scale - current_scale) / grow_delay * delta+ current_scale)
