extends Node2D


export var player_group_id = "player"
export var emits_per_second = 1.0
# one of 0, 1, 2 (0 is sad, 1 is medium, 2 is happy)
export(int, "Sad", "Ok", "Happy") var happy_state = 0
export var emitting = false


var sun_animations = ["sad", "ok", "happy"]
var controller


func _process(delta):
	# Set animated sprites current animation from the happy_state ivar
	$AnimatedSprite.animation = sun_animations[happy_state]
	if self.emitting and not self.controller:
		self.create_controller()
	elif not self.emitting and self.controller:
		self.destroy_controller()
	update()
	
func create_controller():
	self.controller = Node2D.new()
	self.controller.name = "ArrowController"
	self.controller.set_script(load("res://Src/ArrowController.gd"))
	self.controller.player_group_id = self.player_group_id
	self.controller.emits_per_second = self.emits_per_second
	self.get_parent().add_child(self.controller)
	self.controller.set_owner(self.get_parent())
	self.controller.global_position = self.global_position

	

func destroy_controller():
	print("destroy controller")
	for child in self.controller.get_children():
		self.controller.remove_child(child)
	self.controller.queue_free()
	self.controller = null
