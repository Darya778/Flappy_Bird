extends Node2D

@export var speed: float = 200.0
var counted:bool = false
signal passed

@onready var score_zone = get_node("StaticBody2D/Check")

func _ready():
	score_zone.monitoring = true
	score_zone.body_entered.connect(_on_score_zone_entered)
	
func _process(delta):
	position.x -= speed * delta
	if position.x < -400:
		queue_free()
func _on_score_zone_entered(body):
	if body.name == "Bird" and not counted:
		counted = true
		score_zone.set_deferred("monitoring",false)
		emit_signal("passed")
