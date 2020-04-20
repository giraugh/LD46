extends Sprite

var is_dead setget set_dead, get_dead

var alive_texture = self.texture
var dead_texture

func _ready():
	var dead_texture_path = str(self.get_path()).replace("alive", "dead")
	dead_texture = load(dead_texture_path)

func get_dead():
	return is_dead

func set_dead(value):
	if value and not is_dead:
		print("Kill leaf")
		is_dead = value
		self.set_texture(dead_texture)
	elif not value and is_dead:
		is_dead = value
		self.set_texture(alive_texture)
