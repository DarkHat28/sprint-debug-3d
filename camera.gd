extends Camera3D

@onready var player: CharacterBody3D = %Player

# Sensitivity settings
@export var vertical_angle_limit: float = 45.0
@export var mouse_sensitivity: float = 0.002

# Rotation variables
var mouse_rotation: Vector2 = Vector2.ZERO

func _ready():
	# Make sure mouse is captured
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_rotation = event.relative * mouse_sensitivity
		rotate_camera()
	
	# Toggle mouse capture
	if Input.is_action_just_pressed("ui_cancel"):
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
	rotation.x = clamp(rotation.x, deg_to_rad(-vertical_angle_limit), deg_to_rad(vertical_angle_limit))


#@onready var player: CharacterBody3D = %Player
#
#@export_range(-90, 0.0, 0.1, "radians_as_degrees") var min_vertical_angle: float = -PI/2
#@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var max_vertical_angle: float = PI/4
#@export_range(0.0001, 0.5, 0.0001) var mouse_sensitivity: float = 0.005
#
#
#func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#player.rotation.y = rotation.y
#
#func _physics_process(_delta: float) -> void: pass
#
#func _input(event: InputEvent) -> void:
	#mouse_rotation(event)
	#_grab_mouse()
#
#func mouse_rotation(event: InputEvent) -> void:
	#if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#player.rotation.x -= event.relative.y * mouse_sensitivity # Vertical Camera Movement
		#player.rotation.x = clampf(rotation.x, min_vertical_angle, max_vertical_angle)
		#player.rotation.y -= event.relative.x * mouse_sensitivity # Horizontal Camera Movement
		#player.rotation.y = wrapf(rotation.y, 0.0, TAU)
#
#func _grab_mouse() -> void:
## toggle mouse capture (Escape toggles)
	#if Input.is_action_pressed("toggle_mouse_capture"):
		#if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#else:
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
