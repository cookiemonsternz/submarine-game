extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var vel_y = 0

var look_sensitivity = ProjectSettings.get_setting("player/look_sensitivity")

@export var speed = 5
@export var jump_velocity = 3

@onready var camera:Camera3D = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	var horizontal_vel = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = (horizontal_vel.x * global_transform.basis.x + horizontal_vel.y * global_transform.basis.z) * speed
	if is_on_floor():
		vel_y = 0
		print("Touching floor")
		if Input.is_action_just_pressed("jump"): vel_y = jump_velocity
	else:
		vel_y -= gravity * delta
	velocity.y = vel_y
	move_and_slide()
	if Input.is_action_just_pressed("ui_cancel"): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
