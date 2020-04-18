extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
export var global_time = 0
export var periods = 1.0
export var speed = .95
export var swing = 20.0
export var heightMid = 150.0
export var bounce = 20.0
export var leafHeight = 100.0
export var softness = 5.0


func _process(delta):
	global_time += delta
	var height = get_height(global_time)
	$head.set_position(Vector2(xposplayer(height,height, global_time), -height))
	$head.set_rotation(head_angle(global_time))
	$leaf.set_position(Vector2(xposplayer(leafHeight, height, global_time), -leafHeight))
	var rotation = $leaf.get_rotation()
	var wantedRotation = angle_player(leafHeight, global_time)
	$leaf.set_rotation((wantedRotation - rotation) / softness + rotation)
	update()
	
func get_height (time):
	return heightMid + bounce * sin(2 * periods * 2 * PI * time * speed)
	
func angle_player(h, time):
	var height = get_height(time)
	return atan(periods * 2 * PI * (h / height) / height * swing * cos(periods * 2 * PI * (h / height + time * speed)) )
	
	
func head_angle(time):
	var height = get_height(time)
	return atan(periods * 2 * PI / height * swing * cos(periods * 2 * PI * (1 + time * speed)) )

func xposplayer(h, height, time):
	return h / height * swing * sin(periods * 2 * PI * (h / height + time * speed)) 

func _draw():
	var height = get_height(global_time)
	
	for i in range(int(height)):
		draw_line(Vector2(xposplayer(i, height, global_time) + 2.5,-i), Vector2(xposplayer(i+1, height,global_time) + 2.5, -(i+1)), Color("#3e8948"), 11)
		draw_line(Vector2(xposplayer(i, height, global_time) - 5.5,-i), Vector2(xposplayer(i+1, height,global_time) - 5.5, -(i+1)), Color("#265c42"), 5)
	
