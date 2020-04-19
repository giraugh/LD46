extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var background_original_scale = Vector2(0,0)
var background_original_position = Vector2(221,587)
var background_target_position = Vector2(221,587)
# Called when the node enters the scene tree for the first time.
func _ready():
	background_original_scale = get_parent().get_node("Scenery").get_scale()

export var phase = 0
export var background = "background-gardenl"
# Called every frame. 'delta' is the elapsed time since the previous frame.
var global_time = 0
func _process(delta):
	global_time += delta
	phase = (1 + sin(global_time)) / 2
	var zoom = lerp(4,1.3, phase)
	var background = get_parent ().get_node("Scenery")
	background.set_scale(background_original_scale * zoom / 1.3)
	background.set_position(background_original_position.linear_interpolate(background_target_position, phase))
	set_offset(Vector2(0,lerp(0,80, phase)))
	set_zoom(Vector2(1,1) * zoom)
