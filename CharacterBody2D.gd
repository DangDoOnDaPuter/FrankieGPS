extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var multijump: bool

func _physics_process(delta):
	wrap_around_screen()
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or multijump):
		velocity.y = JUMP_VELOCITY
		multijump = is_on_floor() or not multijump
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if not direction:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$"AnimatedSprite2D".play("idle")
	else:
		velocity.x = direction * SPEED
		$"AnimatedSprite2D".flip_h = direction < 0
		var animation = "idle" if not is_on_floor() else "running"
		$"AnimatedSprite2D".play(animation)
		
	move_and_slide()
	
func wrap_around_screen():
	var screen_size = get_viewport_rect().size

	if position.x > screen_size.x:
		position = Vector2(0,150)
	elif position.x < 0:
		position = Vector2(1366,560)

func _on_area_2d_body_entered(body):
	position = Vector2(179,149)
