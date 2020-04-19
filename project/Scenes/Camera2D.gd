extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var global_time = 0
func _process(delta):
	global_time += delta
	set_zoom(Vector2(1,1) * lerp(0.5,1, ((1 + sin(global_time)) / 2)))
