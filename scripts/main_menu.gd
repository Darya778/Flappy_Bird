extends Control

@export var bg_speed := 20.0
@export var floor_speed := 120.0

var bg_sprites := []
var floor_sprites := []

var bg_width: float
var floor_width: float

@onready var Animations = get_node("Background/BirdNode/AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Animations.play("idle")
	Animations.play("idle_transforming")
	
	bg_sprites = [get_node("Background/bg_1"), get_node("Background/bg_2"), get_node("Background/bg_3")]
	floor_sprites = [get_node("Background/flo_1"), get_node("Background/flo_2"), get_node("Background/flo_3")]

	bg_width = bg_sprites[0].texture.get_size().x * bg_sprites[0].scale.x
	floor_width = floor_sprites[0].texture.get_size().x * floor_sprites[0].scale.x

	for i in range(3):
		bg_sprites[i].position.x = bg_width * i
		floor_sprites[i].position.x = floor_width * i

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit(0)
