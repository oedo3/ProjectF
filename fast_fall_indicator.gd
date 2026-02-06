extends MeshInstance2D

@export var flash_time := 0.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player := get_parent() as CharacterBody2D
	if player == null:
		return
	
	# Fast fall indicator
	if Input.is_action_just_pressed("down") and not player.is_on_floor():
			flash()
			
func flash():
	visible = true
	await get_tree().create_timer(flash_time).timeout
	visible = false
			
