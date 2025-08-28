extends CharacterBody3D

@onready var camera: Camera3D = %Camera

# For key Debugging
@onready var input_label: Label = %InputLabel
@onready var update_timer: Timer = %UpdateTimer
var pressed_keys: Dictionary = {}
var current_fps: float = 0

@export_group("Movement")
@export var walk_speed := 3.0
@export var sprint_speed := 6.0
@export var acceleration: float = 30.0
@export var friction: float = 50.0

@export_group("Jump")
@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3
## Calculated 
@onready var jump_velocity: float = -(2.0 * jump_height / jump_time_to_peak)
@onready var jump_gravity: float = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity: float = (2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)
## source: https://youtu.be/IOe1aGY6hXA?feature=shared

## Input Realted Variables
var input_dir: Vector2
var direction: Vector3
var is_sprinting: bool = false
var is_jumping: bool = false


func _ready():
	# Make sure the mouse is captured when the game starts
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	input_label.text = "Ready - press keys!"

func _input(event):
	debugg_input(event)

func _physics_process(delta):
	view_fps()
	
	is_jumping = Input.is_action_just_pressed("jump")
	is_sprinting = Input.is_action_pressed("sprint")
	
	# Get input direction
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	horizontal_movement(delta)
	jump()
	apply_gravity(delta)
	move_and_slide()

func horizontal_movement(delta: float) -> void:
	# Apply movement
	if direction:
		if is_on_floor():
			if is_sprinting:
				start_horizontal_velocity(delta, sprint_speed)
			else:
				start_horizontal_velocity(delta, walk_speed)
	else:
		stop_horizontal_velocity(delta)

func jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_velocity

func start_horizontal_velocity(delta: float, speed: float) -> void:
	velocity.x = move_toward(velocity.x, direction.x * speed, delta * acceleration)
	velocity.z = move_toward(velocity.z, direction.z * speed, delta * acceleration)

func stop_horizontal_velocity(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, delta * friction)
	velocity.z = move_toward(velocity.z, 0, delta * friction)

func apply_gravity(delta: float) -> void:
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		velocity.y = min(velocity.y, gravity) # Limit fall speed
		#print("If Not is-on-floor: ", gravity)
	#print("If is-on-floor: ", gravity)

func debugg_input(event):
	if not event is InputEventKey:
		return
	var key_name = OS.get_keycode_string(event.keycode)
	if event.pressed:
		pressed_keys[key_name] = true
	else:
		pressed_keys.erase(key_name)

func view_fps() -> void:
	# Update FPS every physics frame (smoother)
	current_fps = Engine.get_frames_per_second() # For Debugging

func _on_update_timer_timeout():
	var keys_array = pressed_keys.keys()
	var keys_text = "Keys: " + ", ".join(keys_array) if keys_array else "No keys pressed"
	input_label.text = "FPS: " + str(current_fps) + "\n" + keys_text
	#input_label.text = "FPS: " + str(Engine.get_frames_per_second()) + "\nKeys: " + ", ".join(keys_array) if keys_array else "No keys pressed"
