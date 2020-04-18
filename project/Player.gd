extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
export var time = 0
export var periods = 1.0
export var speed = 1.13333333
export var width = 20.0
export var heightMid = 150.0
export var heightVar = 20.0

func _process(delta):
	time += delta
	var height = get_height(time)
	$head.set_position(Vector2(xposplayer(height,height), -height))
	$head.set_rotation(head_angle(time))
	update()

func get_height (time):
	return heightMid + heightVar * sin(2 * periods * 2 * PI * time * speed)
	
func head_angle(time):
	var height = get_height(time)
	return atan(periods * 2 * PI / height * width * cos(periods * 2 * PI * (1 + time * speed)) )

func xposplayer(h, height):
	return h / height * width * sin(periods * 2 * PI * (h / height + time * speed)) 

func _draw():
    var height = get_height(time)
    for i in range(int(height)):
        draw_line(Vector2(xposplayer(i, height),-i), Vector2(xposplayer(i+1, height), -(i+1)), ColorN("green"), 16)