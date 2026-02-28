extends Camera2D

@export var player_body: CharacterBody2D

#Camera Movment with player movment settings
@export var smoothing := 2.5
@export var look_ahead_distance := 1200.0
@export var look_ahead_speed := 1.5


# Zoom settings
@export var zoom_speed := 0.1
@export var min_zoom := 1.0
@export var max_zoom := 2.0

# Y shift range
@export var min_y_offset := 0.0
@export var max_y_offset := -200.0

var target_offset := Vector2.ZERO	
#var target_zoom := Vector2.ONE

func _ready():
	enabled = true
	position_smoothing_enabled = true
	position_smoothing_speed = smoothing
	
func _process(delta):
	
	if player_body == null:
		return
	
	# Camera follow player without teleporting
	global_position = global_position.lerp(
		player_body.global_position,
		smoothing * delta
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

	# Look-ahead logic
	if abs(velocity.x) > 10.0:
		target_offset.x = sign(velocity.x) * scaled_look_ahead
	else:
		target_offset.x = 0.0
			
	#Smooth offset movement
	offset.x = lerp(offset.x, target_offset.x, look_ahead_speed * delta)
	
	#Smooth y shift
	offset.y = lerp(offset.y, lerp(min_y_offset, max_y_offset, zoom_t), look_ahead_speed * delta)
	
	#Zoom input
	if Input.is_action_just_pressed("zoom_in"):
		zoom += Vector2.ONE * zoom_speed
		
	if Input.is_action_just_pressed("zoom_out"):
		zoom -= Vector2.ONE * zoom_speed
	
	#Clamp zoom
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)
	
	
	
	
