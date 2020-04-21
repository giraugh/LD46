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
export var growth_target = 0.0
export var growth_softness = 2
export var growth_amount = 0.01
export var shrink_amount = 0.05
export var leaf_difference = 25.0
export var leaf_distance_from_head = 50.0
export var left_leaf_next = true
export var max_leaf_bounce = PI / 4
var in_zone = false
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
	
	var expected_leaf_count = int((heightMid - leaf_distance_from_head) / leaf_difference)
	if len(leaves) < expected_leaf_count:
		create_leaf()
	elif len(leaves) > expected_leaf_count:
		kill_leaf()
	for leaf in leaves:
		update_leaf(leaf, height)
	growth += (growth_target - growth) / growth_softness
	update()
	
func update_leaf(leaf, height):
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
	
func create_leaf():
	var new_leaf = load("res://Scenes/Leaf.tscn").instance()
	if not left_leaf_next:
		new_leaf.set_scale(Vector2(-1,1))
	left_leaf_next = not left_leaf_next
	add_child(new_leaf)
	leaves.append({ "node": new_leaf, "height": heightMid - 50})

func kill_leaf():
	if leaves:
		var leaf_target = leaves.pop_back()
		leaf_target["node"].queue_free()

	
# Handle key press events for nodes inside the plant pot
func _unhandled_key_input(event):
	var arrows = get_tree().get_nodes_in_group("node_in_plant")
	print_debug("Handling event for ", event, " on nodes ", arrows)	
	if len(arrows):
		var target_arrow = arrows[0]
		var orientation = target_arrow.orientation
		if event.is_action_pressed("ui_" + orientation):
			on_arrow_hit(target_arrow)
		else:
			on_arrow_miss(target_arrow)

func on_arrow_miss(arrow):
	print_debug("Action Miss")
	self.shrink()
	arrow.current_state = "bad"
	arrow.remove_from_group("node_in_plant")
	$"sprite-okbox".animation = 'bad' # box will reset itself after a delay
	
func on_arrow_hit(arrow):
	print_debug("Action Hit")
	grow()
	arrow.current_state = "great"
	arrow.remove_from_group("node_in_plant")
	# Create Effect
	$"sprite-okbox".animation = 'good'# box will reset itself after a delay
	var effect = load("res://Scenes/ArrowTrail.tscn").instance()
	effect.position = Vector2(0, 0)
	effect.orientation = arrow.orientation
	$"sprite-okbox".add_child(effect)
	
	# Add Score
	#$"/root/World/Scenery/Score".add_score(5)

func grow():
	growth_target = min(1, growth_amount + growth_target)

func shrink():
	growth_target = max(0, growth_target - shrink_amount)
	

func get_height (time):
	var heightMid = lerp(minHeight, maxHeight, growth)
	var bounce = lerp(minBounce, maxBounce, growth)
	return heightMid + bounce * sin(2 * periods * 2 * PI * time * speed)

func angle_player(h, time):
	var height = get_height(time)

	return atan(periods * 2 * PI * (h / height) / height * swing * cos(periods * 2 * PI * (h / height + time * speed)) )

func did_hit(arrow):
	# Grow Plant
	grow()
	
	

func did_miss(arrow):
	shrink()


func head_angle(time):
	var height = get_height(time)
	return angle_player(height, time)

func xposplayer(h, height, time):
	var heightMid = lerp(minHeight, maxHeight, growth)
	var bounce = lerp(minBounce, maxBounce, growth)
	var swing = lerp(minSwing, maxSwing, growth)
	return h / height * swing * sin(periods * 2 * PI * (h / height + time * speed))

func _draw():
	# Refactored this to draw a single polygon which scales much better (rendering is expensive)
	var height = get_height(global_time)
	var polygon_pool_primary = PoolVector2Array()
	var polygon_pool_secondary = PoolVector2Array()
	
	for i in range(int(height)):
		polygon_pool_primary.append(Vector2(xposplayer(i+1, height,global_time) + 2.5, -(i+1)))
		polygon_pool_secondary.append(Vector2(xposplayer(i+1, height,global_time) - 5.5, -(i+1)))
		#draw_line(Vector2(xposplayer(i, height, global_time) + 2.5,-i), Vector2(xposplayer(i+1, height,global_time) + 2.5, -(i+1)), Color("#3e8948"), 11)
#		draw_line(Vector2(xposplayer(i, height, global_time) - 5.5,-i), Vector2(xposplayer(i+1, height,global_time) - 5.5, -(i+1)), Color("#265c42"), 5)
	draw_polyline(polygon_pool_primary, Color("#3e8948"), 11)
	draw_polyline(polygon_pool_secondary, Color("#265c42"), 5, true)
	

func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	var scene = area.get_parent()
	print("Add scene ", scene)
	scene.add_to_group("node_in_plant")


func _on_Area2D_area_shape_exited(area_id, area, area_shape, self_shape):
	if area:
		var scene = area.get_parent()
		if scene.is_in_group("node_in_plant"):
			on_arrow_miss(scene)
