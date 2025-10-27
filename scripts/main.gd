extends Node2D

@export var bg_speed := 20.0
@export var floor_speed := 120.0

var bg_sprites := []
var floor_sprites := []

var bg_width: float
var floor_width: float
var game_started: bool = false

func _ready():
	bg_sprites = [get_node("bg_1"), get_node("bg_2"), get_node("bg_3")]
	floor_sprites = [get_node("flo_1"), get_node("flo_2"), get_node("flo_3")]

	bg_width = bg_sprites[0].texture.get_size().x * bg_sprites[0].scale.x
	floor_width = floor_sprites[0].texture.get_size().x * floor_sprites[0].scale.x

	for i in range(3):
		bg_sprites[i].position.x = bg_width * i
		floor_sprites[i].position.x = floor_width * i

func _process(delta):
	if not game_started:
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			game_started = true
		return
		
	_scroll_layer(bg_sprites, bg_speed, delta)
	_scroll_layer(floor_sprites, floor_speed, delta)

func _scroll_layer(sprites: Array, speed: float, delta: float):
	var width = sprites[0].texture.get_size().x * sprites[0].scale.x

	for sprite in sprites:
		sprite.position.x -= speed * delta

	for i in range(sprites.size()):
		if sprites[i].position.x <= -width:
			var max_x = -INF
			for j in range(sprites.size()):
				if j != i:
					max_x = max(max_x, sprites[j].position.x)
			sprites[i].position.x = max_x + width
