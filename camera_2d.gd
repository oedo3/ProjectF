extends Camera2D

@export var smoothing := 2.5
@export var look_ahead_distance := 600.0
@export var look_ahead_speed := 6.0

var target_offset := Vector2.ZERO

func _ready():
	enabled = true
	position_smoothing_enabled = true
	position_smoothing_speed = smoothing
	
func _process(delta):
	var body := get_parent() as CharacterBody2D
	if body == null:
		return
	
	var velocity: Vector2 = body.velocity
		
	#Only look ahead when actually moving
	if abs(velocity.x) > 10.0:
		target_offset.x = sign(velocity.x) * look_ahead_distance
			
	else:
		target_offset.x = 0
			
	#Smoothly move the camera offset
	position.x = lerp(position.x, target_offset.x, look_ahead_speed * delta)
