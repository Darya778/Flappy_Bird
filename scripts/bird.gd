extends CharacterBody2D

const GREVITY: float = 800.0
const JUMP_FORCE: float = 300.0
const MAX_FALL_SPEED: float = 500.0  # ограничение скорости падения
const TILT_SPEED: float = 6.0    # скорость реакции наклона
const MAX_TILT_UP: float = -25.0 # максимальный угол при взлёте 
const MAX_TILT_DOWN: float = 70.0 # максимальный угол при падении

@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var anim: AnimationPlayer = get_node("AnimationPlayer")

var game_started: bool = false

func _physics_process(delta: float) -> void:
	if not game_started:
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			game_started = true
			anim.play("fly")
		return  # пока не начата, не двигаем птицу
	
	
	velocity.y += GREVITY * delta
	velocity.y = clamp(velocity.y, -JUMP_FORCE, MAX_FALL_SPEED)

	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		velocity.y = -JUMP_FORCE
		anim.play("fly")

	move_and_slide()

	# наклон
	var target_angle: float

	if velocity.y < -50:
		target_angle = deg_to_rad(MAX_TILT_UP)
	elif velocity.y > 150: 
		target_angle = deg_to_rad(MAX_TILT_DOWN)
	else:
		target_angle = lerp_angle(deg_to_rad(MAX_TILT_UP), deg_to_rad(MAX_TILT_DOWN), velocity.y / MAX_FALL_SPEED)

	rotation = lerp_angle(rotation, target_angle, delta * TILT_SPEED)
