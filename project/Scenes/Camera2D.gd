extends Camera2D

export(int) var ease_duration = 4 # in seconds

var background_original_scale = Vector2(0,0)
var background_original_position = Vector2(221,587)
var background_target_position = Vector2(221,587)
var zoom_start = 4
var zoom_end = 1.3
var global_time = 0
var state = 'menu'

func _ready():
	background_original_scale = get_parent().get_node("Scenery").get_scale()

export var phase = 0

# Zoom into window to show game
func show_game():
	state = 'game'

# Zoom out from window to hide game
func show_menu():
	state = 'menu'
	get_node("/root/World/Scenery/Sun").emitting = false

func _process(delta):
	# Increment time
	if state == 'game':
		global_time = min(global_time + delta, ease_duration) 
	else:
		global_time = max(global_time - delta, 0)
	
	# Phase is time percentage with ease function applied
	phase = easeInOutSine(min(1, global_time / ease_duration))
	
	# Calculate zoom
	var zoom = lerp(zoom_start, zoom_end, phase)
	var background = get_parent().get_node("Scenery")
	
	# Set positions, scale and zoom for this step
	background.set_scale(background_original_scale * zoom / zoom_end)
	background.set_position(background_original_position.linear_interpolate(background_target_position, phase))
	set_offset(Vector2(0,lerp(0,80, phase)))
	set_zoom(Vector2(1,1) * zoom)
	
	if phase == 1:
		var sun = get_node("/root/World/Scenery/Sun")
		sun.emitting = true

# Utility for easing function
func easeInOutSine(x):
	return -(cos(PI * x) - 1) / 2


func _on_TextureButton_pressed():
	state = "game"

	
func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		show_menu()
