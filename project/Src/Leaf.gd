extends Node2D

onready var sprites = [
	#get_node("leaf-1"),
	get_node("leaf-2"),
	#get_node("leaf-3"),
	#get_node("leaf-4"),
	#get_node("leaf-5")
]

var target_scale = Vector2(0,0)
var grow_delay = 3.0
# Called when the node enters the scene tree for the first time.
func _ready():
	sprites[randi() % len(sprites)].visible = true
	target_scale = get_scale()
	set_scale(Vector2(0,0))

var global_time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_time += delta
	var current_scale = get_scale()
	set_scale((target_scale - current_scale) / grow_delay * delta+ current_scale)
