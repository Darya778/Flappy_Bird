extends Node2D

const SCROLL_SPEED: float = 10.0
var game_started: bool = false

var layers = []

func _ready():
	layers = [
		{
			"nodes": [get_node("bg_1"), get_node("bg_2")],
			"speed": SCROLL_SPEED,
			"width": get_node("bg_1").texture.get_size().x
		},
		{
			"nodes": [get_node("flo_1"), get_node("flo_2")],
			"speed": SCROLL_SPEED * 2,
			"width": get_node("flo_1").texture.get_size().x
		}
	]

func _process(delta):
	# Ожидание старта
	if not game_started:
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			game_started = true
		return

	for layer in layers:
		_scroll_layer(layer, delta)

func _scroll_layer(layer: Dictionary, delta: float) -> void:
	var nodes = layer["nodes"]
	var speed = layer["speed"]
	var width = layer["width"]

	for n in nodes:
		n.position.x -= speed * delta

		if n.position.x <= -width:
			var max_x = -INF
			for m in nodes:
				if m != n:
					max_x = max(max_x, m.position.x)
			n.position.x = max_x + width
