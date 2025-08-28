extends Camera3D

@onready var player: CharacterBody3D = %Player

# Sensitivity settings
@export var mouse_sensitivity: float = 0.002 # Usually very small number ex: 0.002
@export_range(-90, 0.0, 0.1, "radians_as_degrees") var min_vertical_angle: float = 45.0 # min_vertical_angle = Down limit
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var max_vertical_angle: float = 25.0 # min_vertical_angle = Up limit

# Rotation variables
var mouse_rotation: Vector2 = Vector2.ZERO

func _ready():
	# Make sure mouse is captured
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# Mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_rotation = event.relative * mouse_sensitivity
		rotate_camera()
	
	# Toggle mouse capture
	if Input.is_action_just_pressed("toggle_mouse_capture"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	# Smoothly rotate the camera
	if mouse_rotation.length() > 0:
		rotate_camera()
		mouse_rotation = Vector2.ZERO

func rotate_camera():
	# Rotate the player horizontally
	player.rotate_y(-mouse_rotation.x)
	
	# Rotate the camera vertically
	rotation.x -= mouse_rotation.y
	rotation.x = clamp(rotation.x, deg_to_rad(-min_vertical_angle), deg_to_rad(max_vertical_angle))
