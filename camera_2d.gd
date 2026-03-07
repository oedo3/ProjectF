extends Camera2D

@export var player_body: CharacterBody2D

#Camera Movment with player movment settings
@export var smoothing := 2.5
@export var look_ahead_distance := 600.0
@export var look_ahead_speed := 1.5


# Zoom settings
@export var zoom_speed := 0.1
@export var min_zoom := 1.5
@export var max_zoom := 6

# Y shift range
@export var min_y_offset := 0.0
@export var max_y_offset := -0.0

@export var direction_change_delay := 0.0

var direction_timer := 0.0
var last_direction := 0

var target_offset := Vector2.ZERO	
#var target_zoom := Vector2.ONE

func _ready():
	enabled = true
	position_smoothing_enabled = true
	position_smoothing_speed = smoothing
	
func _process(_delta):
	
	if player_body == null:
		return
	
	# Camera follow player without teleporting
	global_position = global_position.lerp(
		player_body.global_position,
		smoothing * _delta
	)
	
	var velocity: Vector2 = player_body.velocity
	
	# Normalize zoom (0 = zoomed in, 1 = zoomed out)
	var zoom_t := (zoom.x - min_zoom) / (max_zoom - min_zoom)
	zoom_t = clamp(zoom_t, 0.0, 1.0)

	# Scale look ahead with zoom
	var scaled_look_ahead := lerpf(
		look_ahead_distance,
		look_ahead_distance * 0.2,
		zoom_t
	)

	var dir: int = int(sign(velocity.x))

	# Detect direction change
	if dir != last_direction and dir != 0:
		direction_timer = 0.0
		last_direction = dir

	direction_timer += _delta

	# Apply lookahead only after delay
	var desired_offset_x := 0.0
	
	if abs(velocity.x) > 10.0 and direction_timer > direction_change_delay:
		desired_offset_x = dir * scaled_look_ahead
		
	# Smoothly move target offset
	target_offset.x = lerp(target_offset.x, desired_offset_x, 4.0 * _delta)
			
	#Smooth offset movement
	offset.x = lerp(offset.x, target_offset.x, look_ahead_speed * _delta)
	
	#Smooth y shift
	offset.y = lerp(offset.y, lerp(min_y_offset, max_y_offset, zoom_t), look_ahead_speed * _delta)
	
	#Zoom input
	if Input.is_action_just_pressed("zoom_in"):
		zoom += Vector2.ONE * zoom_speed
		
	if Input.is_action_just_pressed("zoom_out"):
		zoom -= Vector2.ONE * zoom_speed
	
	#Clamp zoom
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)
	
	
	
	
	
