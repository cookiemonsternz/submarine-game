extends RigidBody3D


var mouse_since_moved := 0.0
var mouse_stopped_move := 0.3

var look_sensitivity = 0.02
var look_sensitivity_vertical = 0.0028

@onready var camera:Camera3D = $Camera3D

@export var speed = 3

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	mouse_since_moved += delta
	
	if mouse_since_moved > mouse_stopped_move:
		angular_velocity = angular_velocity.lerp(Vector3.ZERO, 7.50 * delta)
	
	print(mouse_since_moved)
	var directional_vel = Input.get_vector("left", "right", "up", "down")
	
	var vertical_direction = Input.get_axis("lower", "rise")
	
	var vertical_force_vector = Vector3(0.0, vertical_direction * speed, 0.0)
	
	apply_force(vertical_force_vector)
	
	#velocity = (directional_vel.x * global_transform.basis.x + directional_vel.y * global_transform.basis.z) * speed
	var direction_vel_3 = Vector3(directional_vel.x, 0.0, directional_vel.y)
	#print(direction_vel_3)
	#print(global_basis.z)
	var force = (to_global(direction_vel_3) - global_position) * speed
	apply_force(force)
	
	if Input.is_action_just_pressed("ui_cancel"): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		mouse_since_moved = 0.0
		apply_torque(Vector3.UP * -event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity_vertical)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/3.5)
