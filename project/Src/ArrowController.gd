extends Node2D

var time = 0.0
var lastEmit = 0.0
export var player_group_id = ""
export var emits_per_second = 1.0
export var arrows = []



# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")

func _process(delta):
	time += delta

	lastEmit += delta
	if lastEmit > (1 / emits_per_second) :
		lastEmit = 0.0
		self.spawn_arrow()

func spawn_arrow():
	var child = load("res://Scenes/Arrow.tscn").instance()
	var player_nodes = self.get_tree().get_nodes_in_group(player_group_id)
	print("Generating arrow")
	if player_nodes:
		self.add_child(child)
		child.set_player(player_nodes[0])
		child.set_orientation(randi() % 4)
	else:
		print_debug('Warning: No player objects in group ', player_group_id, ', arrows will not spawn.')
		child.queue_free()
