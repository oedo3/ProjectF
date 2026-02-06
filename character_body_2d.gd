extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -700.0
const JUMP_BUFFER_TIME := 0.15

const DASH_SPEED := 1800.0
const DASH_TIME := 0.12
const DASH_COOLDOWN := 0.4

var weight := 1.2
var jump_buffer := 0.0
var is_dashing := false
var dash_timer := 0.0
var dash_cooldown := 0.0

func _physics_process(delta: float) -> void:
	# Cooldowns
	if dash_cooldown > 0:
		dash_cooldown -= delta

	# Dash start
	if Input.is_action_just_pressed("s_1") and dash_cooldown <= 0:
		is_dashing = true
		dash_timer = DASH_TIME
		dash_cooldown = DASH_COOLDOWN

		var dir := Input.get_axis("left", "right")
		if dir == 0:
			dir = sign(velocity.x)
			if dir == 0:
				dir = 1

		velocity.x = dir * DASH_SPEED
		velocity.y = 0

	# Dash active
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	else:
		# Gravity
		if not is_on_floor():
			velocity += get_gravity() * delta * weight

		# Jump buffer input
		if Input.is_action_just_pressed("up"):
			jump_buffer = JUMP_BUFFER_TIME

		if jump_buffer > 0:
			jump_buffer -= delta

		if jump_buffer > 0 and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_buffer = 0

		# Fast fall
		if Input.is_action_just_pressed("down"):
			velocity.y = JUMP_VELOCITY * -1

		# Horizontal movement
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
