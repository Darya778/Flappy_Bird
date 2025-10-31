extends Node2D

@export var pipe_scene: PackedScene = preload("res://scenes/pipe.tscn")
const SFX_POINT = preload("res://assets/audio/point.wav")
@onready var parent = get_parent()
@onready var score_img1 = parent.get_node("Score_one")
@onready var score_img2 = parent.get_node("Score_ten")
@onready var bird = parent.get_node("Bird")
@onready var sound = parent.get_node("Sound")
@export var spawn_interval: float = 2.0
@export var start_x: float = 800.0
@export var min_y: float = 200        # смещение вверх
@export var max_y: float = 550        # смещение вниз
@export var pipe_speed: float = 200.0

var score_one = 0
var score_two = 0
var timer := 0.0
var game_started: bool = false
var game_end = false

func _ready():
	bird.hit.connect(_stop_pipe)
	score_img2.visible = false
	
func _process(delta):
	if not game_started:
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			game_started = true
			print("Game started!")
		return
	
	if not game_end:
		timer += delta
		if timer >= spawn_interval:
			timer = 0
			spawn_pipe()
	

func _on_pipe_passed():
	_add_score()
	sound.stream = SFX_POINT
	sound.play()
func _add_score():
	
	score_one+=1
	if score_one==10:
		score_one = 0
		score_two +=1
		var path2 = "res://assets/numbers/%d.png" % score_two
		var tex2 = load(path2)
		score_img2.texture = tex2
		score_img2.visible = true		
	var path = "res://assets/numbers/%d.png" % score_one
	var tex = load(path)
	score_img1.texture = tex

func spawn_pipe():
	if pipe_scene == null:
		print("Error: pipe_scene is null!")
		return
	
	var pipe = pipe_scene.instantiate()
	pipe.counted = false 
	pipe.passed.connect(Callable(self, "_on_pipe_passed"))
	var random_y = randf_range(min_y, max_y)
	pipe.position = Vector2(start_x, random_y)
	
	add_child(pipe)
	
	pipe.set("speed", pipe_speed)
	
func _stop_pipe():
	game_end = true
	stop_all_childs()

func stop_all_childs():
	for child in get_children():
		child.set("speed",0)
