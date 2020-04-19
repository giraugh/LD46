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
export var leafHeight = 100.0
export var softness = 5.0
export var minBounce = 1.0
export var maxBounce = 30.0
export var minSwing = 1.0
export var maxSwing = 30.0
export var minHeight = 50.0
export var maxHeight = 300
var heightMid = 0.0
var bounce = 0.0
var swing = 0.0
export var growth = 0.0
export var leaf_difference = 25.0
export var leaf_distance_from_head = 50.0
export var left_leaf_next = true
export var max_leaf_bounce = PI / 4
var leaves = []

func _process(delta):
	global_time += delta
	#growth = global_time / 30
	var height = get_height(global_time)
	$head.set_position(Vector2(xposplayer(height,height, global_time), -height))
	$head.set_rotation(head_angle(global_time))

	heightMid = lerp(minHeight, maxHeight, growth)
	bounce = lerp(minBounce, maxBounce, growth)
	swing = lerp(minSwing, maxSwing, growth)

	if len(leaves) < int((heightMid - leaf_distance_from_head) / leaf_difference):
		var new_leaf = load("res://Scenes/Leaf.tscn").instance()
		if not left_leaf_next:
			new_leaf.set_scale(Vector2(-1,1))
		left_leaf_next = not left_leaf_next
		add_child(new_leaf)
		leaves.append({ "node": new_leaf, "height": heightMid - 50})
	for leaf in leaves:
		var leaf_node = leaf["node"]
		var bounce_stretch = get_height(global_time) / heightMid
		var leaf_height = leaf["height"] * bounce_stretch

		leaf_node.set_position(Vector2(xposplayer(leaf_height, height, global_time), -leaf_height))
		var rotation = leaf_node.get_rotation()
		var bounce_phase = (get_height(global_time) - heightMid) / bounce

		# Includes considerations for how far up the leaf is, how
		# and how bouncy we actually are
		var this_leaf_bounce = bounce_phase * (leaf_height / heightMid) * (bounce / maxBounce) * max_leaf_bounce

		var wantedRotation = angle_player(leaf_height, global_time) + this_leaf_bounce
		leaf_node.set_rotation((wantedRotation - rotation) / softness + rotation)
	update()

func get_height (time):
	var heightMid = lerp(minHeight, maxHeight, growth)
	var bounce = lerp(minBounce, maxBounce, growth)
	return heightMid + bounce * sin(2 * periods * 2 * PI * time * speed)

func angle_player(h, time):
	var height = get_height(time)

	return atan(periods * 2 * PI * (h / height) / height * swing * cos(periods * 2 * PI * (h / height + time * speed)) )

	
func head_angle(time):
	var height = get_height(time)
	return angle_player(height, time)

func xposplayer(h, height, time):
	var heightMid = lerp(minHeight, maxHeight, growth)
	var bounce = lerp(minBounce, maxBounce, growth)
	var swing = lerp(minSwing, maxSwing, growth)
	return h / height * swing * sin(periods * 2 * PI * (h / height + time * speed))

func _draw():
	var height = get_height(global_time)
	
	for i in range(int(height)):
		draw_line(Vector2(xposplayer(i, height, global_time) + 2.5,-i), Vector2(xposplayer(i+1, height,global_time) + 2.5, -(i+1)), Color("#3e8948"), 11)
		draw_line(Vector2(xposplayer(i, height, global_time) - 5.5,-i), Vector2(xposplayer(i+1, height,global_time) - 5.5, -(i+1)), Color("#265c42"), 5)
	
