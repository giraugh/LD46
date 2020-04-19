extends Node2D

var time = 0.0
var lastEmit = 0.0
export var PLAYER_GROUP_ID = ""
export var emitsPerSecond = 1.0
export var emitting = false
export var arrows = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	time += delta
	if emitting:
		
		lastEmit += delta
		if lastEmit > (1 / emitsPerSecond) :
			
			lastEmit = 0.0
			self.spawn_arrow()

func spawn_arrow():
	var child = load("res://Scenes/Arrow.tscn").instance()
	var player_nodes = self.get_tree().get_nodes_in_group(PLAYER_GROUP_ID)
	if player_nodes:
		self.add_child(child)
		child.set_player(player_nodes[0])
		var dir = randi() % 4
		var direction = ""
		if dir == 0:
			direction = "up"
		elif dir == 1:
			direction = "right"
		elif dir == 2:
			direction = "down"
		elif dir == 3:
			direction = "left"
		
		child.set_rotation(PI / 2 * dir)
		arrows.append({"direction": direction, "node": child})

	else:
		print_debug('Warning: No player objects in group ', PLAYER_GROUP_ID, ', arrows will not spawn.')
		child.queue_free()
