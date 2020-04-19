extends Node2D

# one of 0, 1, 2 (0 is sad, 1 is medium, 2 is happy)
export(int, "Sad", "Ok", "Happy") var happy_state = 0
export var emitting = false
var sun_animations = ["sad", "ok", "happy"]

func _process(delta):
	# Set animated sprites current animation from the happy_state ivar
	$AnimatedSprite.animation = sun_animations[happy_state]
	$ArrowController.emitting = emitting
