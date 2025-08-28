extends CharacterBody3D

@onready var camera: Camera3D = %Camera

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
@onready var jump_velocity: float = (2.0 * jump_height) / jump_time_to_peak * -1
@onready var jump_gravity: float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak) * -1
@onready var fall_gravity: float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent) * -1
## source: https://youtu.be/IOe1aGY6hXA?feature=shared

## Input Realted Variables
var input_dir: Vector2
var direction: Vector3
var is_sprinting: bool = false

func _ready():
	# Make sure the mouse is captured when the game starts
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	#is_jumping = Input.is_action_just_pressed("jump")
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
