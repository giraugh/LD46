extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 0.0
var lastEmit = 0.0
export var emitsPerSecond = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	time += delta
	lastEmit += delta
	if lastEmit > (1 / emitsPerSecond) :
		lastEmit = 0.0
		var child = load("res://Scenes/Arrow.tscn").instance()
		child.set_rotation(PI / 2 * (randi() % 4))
		add_child(child)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
