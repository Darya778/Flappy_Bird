extends Node2D

@export var pipe_scene: PackedScene = preload("res://scenes/pipe.tscn")
@export var spawn_interval: float = 2.0
@export var start_x: float = 800.0
@export var min_y: float = 200        # смещение вверх
@export var max_y: float = 550        # смещение вниз
@export var pipe_speed: float = 200.0

var timer := 0.0

func _process(delta):
	timer += delta
	if timer >= spawn_interval:
		timer = 0
		spawn_pipe()

func spawn_pipe():
	if pipe_scene == null:
		print("Error: pipe_scene is null!")
		return
	
	var pipe = pipe_scene.instantiate()
	
	var random_y = randf_range(min_y, max_y)
	pipe.position = Vector2(start_x, random_y)
	
	add_child(pipe)
	
	pipe.set("speed", pipe_speed)
	
	print("Pipe spawned at ", pipe.position)
