extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playing_game_music = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_game_music():
	if not playing_game_music:
		set_stream(load("res://Music/bensound-summer.ogg"))
		playing_game_music = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
