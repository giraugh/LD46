extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 0
export var speed = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	time = 0
	set_position(Vector2(0, speed * time))

#alled every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	set_position(Vector2(0, speed * time))
