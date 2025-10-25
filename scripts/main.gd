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
			"speed": SCROLL_SPEED * 10,
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

	if nodes[0].position.x <= -width:
		nodes[0].position.x = nodes[1].position.x + width
	elif nodes[1].position.x <= -width:
		nodes[1].position.x = nodes[0].position.x + width



#extends Node2D
#
#const SCROLL_SPEED: float = 5.0
#@onready var bg_1 = get_node("bg_1")
#@onready var bg_2 = get_node("bg_2")
#@onready var flo_1 = get_node("flo_1")
#@onready var flo_2 = get_node("flo_2")
#
#var bg_width: float
#var fl_width: float
#
#var game_started: bool = false
#
#func _ready():
	#bg_width = bg_1.texture.get_size().x
	#fl_width = flo_1.texture.get_size().x
#
#func _process(delta):
	#if not game_started:
		#if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#game_started = true
		#return  # фон не двигается, пока не начата игра
	#
	#
	#bg_1.position.x -= SCROLL_SPEED * delta
	#bg_2.position.x -= SCROLL_SPEED * delta
	#flo_1.position.x -= SCROLL_SPEED * 10 * delta
	#flo_2.position.x -= SCROLL_SPEED * 10 * delta
#
	#if bg_1.position.x <= -bg_width:
		#bg_1.position.x = bg_2.position.x + bg_width
	#if bg_2.position.x <= -bg_width:
		#bg_2.position.x = bg_1.position.x + bg_width
		#
	#if flo_1.position.x <= -fl_width:
		#flo_1.position.x = flo_2.position.x + fl_width
	#if bg_2.position.x <= -fl_width:
		#bg_2.position.x = flo_1.position.x + fl_width
