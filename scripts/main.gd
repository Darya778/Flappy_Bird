extends Node2D

@export var bg_speed := 20.0
@export var floor_speed := 120.0

@onready var bird = get_node("Bird")
@onready var sound = get_node("Sound")

@onready var dead_screen = get_node("DeadScreen")
@onready var cur_score_label = get_node("DeadScreen/ScoreContainer/CurScore")
@onready var high_score_label = get_node("DeadScreen/ScoreContainer/HighScore")

@onready var score_one = get_node("Score_one")
@onready var score_ten = get_node("Score_ten")

var bg_sprites := []
var floor_sprites := []

var bg_width: float
var floor_width: float
var game_started: bool = false
var game_end: bool = false
const SFX_DIE = preload("res://assets/audio/die.wav")

var score: int = 0
var high_score: int
var high_score_changed: bool = false

func add_score(amount: int):
	score += amount
	#print(score)

func _ready():
	
	# Подгрузка файла с рекордом
	if FileAccess.file_exists("res://scripts/highscore.txt"):
		var file = FileAccess.open("res://scripts/highscore.txt", FileAccess.READ)
		var line = file.get_line()
		high_score = int(line)
		file.close()
	
	dead_screen.visible = false;
	bird.hit.connect(_endgame)
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
	if not game_end:
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
func _endgame():
	if score > high_score:
		high_score_changed = true
		high_score = score
	cur_score_label.text = "Current score: " + str(score)
	high_score_label.text = "High score: " + str(high_score)
	
	score_one.visible = false
	score_ten.visible = false
	
	dead_screen.visible = true;
	sound.stream = SFX_DIE
	sound.play()
	var flash = get_node("Flash")
	flash.flash()
	game_end=true
	print("Game end")

func store_high_score() -> void:
	if FileAccess.file_exists("res://scripts/highscore.txt"):
		var file = FileAccess.open("res://scripts/highscore.txt", FileAccess.WRITE)
		file.store_line(str(high_score))
		file.close()

func _on_restart_button_pressed() -> void:
	if high_score_changed:
		store_high_score()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_menu_button_pressed() -> void:
	if high_score_changed:
		store_high_score()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
