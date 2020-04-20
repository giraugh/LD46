extends Node2D

onready var sprites = [
	#get_node("leaf-1"),
	get_node("leaf-2"),
	#get_node("leaf-3"),
	#get_node("leaf-4"),
	get_node("leaf-5")
]

onready var sprite = sprites[randi() % len(sprites)]

var target_scale = Vector2(0,0)
var grow_delay = 3.0
var is_dead
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.visible = true
	target_scale = get_scale()
	set_scale(Vector2(0,0))

var global_time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_time += delta
	var current_scale = get_scale()
	set_scale((target_scale - current_scale) / grow_delay * delta+ current_scale)
	self.sprite.is_dead = is_dead

