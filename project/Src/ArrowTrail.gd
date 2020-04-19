extends Node2D

var lifetime = 0
var lifespan = .25

var INITIAL_SIZE = 0
var FINAL_SIZE = 1.5

var orientation = 'up'

func _process(delta):
	
	# (orientation is set by parent when created)
	if orientation == 'up':
		set_rotation_degrees(0)
	if orientation == 'right':
		set_rotation_degrees(90)
	if orientation == 'down':
		set_rotation_degrees(180)
	if orientation == 'left':
		set_rotation_degrees(270)
	
	# Slowly lose opacity
	modulate.a = lerp(1, 0, lifetime / lifespan)
	print(lifetime)
	
	# Slowly grow
	set_scale(Vector2.ONE * lerp(INITIAL_SIZE, FINAL_SIZE, lifetime / lifespan))
	
	# Slowly Die
	lifetime += delta
	if lifetime >= lifespan:
		queue_free()
