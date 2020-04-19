extends Node2D

var time = 0.0
var lastEmit = 0.0
export var PLAYER_GROUP_ID = ""
export var emitsPerSecond = 1.0
export var emitting = false
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
		child.set_player(player_nodes[0])
		child.set_rotation(PI / 2 * (randi() % 4))
		self.add_child(child)

	else:
		print_debug('Warning: No player objects in group ', PLAYER_GROUP_ID, ', arrows will not spawn.')
		child.queue_free()
