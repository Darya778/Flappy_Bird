extends CharacterBody2D

const GREVITY: float = 1400.0
const JUMP_FORCE: float = 300.0
const MAX_FALL_SPEED: float = 500.0  # ограничение скорости падения
const TILT_SPEED: float = 6.0    # скорость реакции наклона
const MAX_TILT_UP: float = -25.0 # максимальный угол при взлёте 
const MAX_TILT_DOWN: float = 70.0 # максимальный угол при падении
const SFX_JUMP = preload("res://assets/audio/wing.wav")
const SFX_HIT = preload("res://assets/audio/hit.wav")

@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var sound: AudioStreamPlayer2D = get_node("Sounds")
signal hit
var game_started: bool = false
var game_end = false
var target_angle: float

func handle_collision(delta):
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if "StaticBody2D" in collider.name:
			hit.emit()
			velocity.x = 0
			game_end = true
			var shape = collider.get_node("CollisionShape2D")
			var shape2 = collider.get_node("CollisionShape2D2")
			shape.set_deferred("disabled", true)
			shape2.set_deferred("disabled", true)
			sound.stream = SFX_HIT
			sound.play()
		if "roof" in collider.name:
			hit.emit()
			velocity.x = 0
			game_end = true
			sound.stream = SFX_HIT
			sound.play()
		if "floor" in collider.name:
			hit.emit()
			velocity.x = 0
			game_end = true
			sound.stream = SFX_HIT
			sound.play()
		
func _physics_process(delta: float) -> void:
	if not game_started:
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			game_started = true
			anim.play("fly")
		return  # пока не начата, не двигаем птицу
	if not game_end:
		velocity.y += GREVITY * delta
		velocity.y = clamp(velocity.y, -JUMP_FORCE, MAX_FALL_SPEED)

		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("click"):
			sound.stream = SFX_JUMP
			sound.play()
			velocity.y = -JUMP_FORCE *1.5
			anim.play("fly")

		
		handle_collision(delta)
		if velocity.y < -50:
			target_angle = deg_to_rad(MAX_TILT_UP)
		elif velocity.y > 150: 
			target_angle = deg_to_rad(MAX_TILT_DOWN)
		else:
			target_angle = lerp_angle(deg_to_rad(MAX_TILT_UP), deg_to_rad(MAX_TILT_DOWN), velocity.y / MAX_FALL_SPEED)
		rotation = lerp_angle(rotation, target_angle, delta * TILT_SPEED)
	else:
		velocity.y += GREVITY * delta * 2
		target_angle = deg_to_rad(MAX_TILT_DOWN)
		velocity.y = clamp(velocity.y, -JUMP_FORCE, MAX_FALL_SPEED)
		rotation = lerp_angle(rotation, target_angle, delta * TILT_SPEED)
		
	move_and_slide()
