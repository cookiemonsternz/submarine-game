extends RigidBody3D

var mouse_since_moved := 0.0
var mouse_stopped_move := 0.3

# Direct Node3D reference instead of NodePath
@onready var target_node: Node3D = self.get_parent_node_3d().get_parent_node_3d()  # The mesh or parent node
var last_target_position: Vector3

var look_sensitivity = 0.02
var look_sensitivity_vertical = 0.0028

@onready var camera: Camera3D = $Camera3D

@export var speed = 8
var awake = false

var is_tracking: bool = true

func _ready() -> void:
	camera.current = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if target_node != null:
		last_target_position = target_node.global_transform.origin

func _physics_process(delta: float) -> void:
	
	if target_node == null:
		return
	
	if is_tracking:
		var current_position = target_node.global_transform.origin
		var delta_position = current_position - last_target_position
		global_translate(delta_position)
		last_target_position = current_position

	if Input.is_action_just_pressed("mini_sub"):
		print("pressed T")
		awake = !awake
		camera.current = awake
		
		if not awake:
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
			var spot_tween = %SpotLight3D.create_tween()
			spot_tween.tween_property(%SpotLight3D, "light_energy", 0.0, 1.0)
			spot_tween.set_parallel()
			
			var omni_tween = %OmniLight3D.create_tween()
			omni_tween.tween_property(%OmniLight3D, "light_energy", 0.0, 1.0)
		else:
			var spot_tween = %SpotLight3D.create_tween()
			spot_tween.tween_property(%SpotLight3D, "light_energy", 10.0, 3.0)
			spot_tween.set_parallel()
			
			var omni_tween = %OmniLight3D.create_tween()
			omni_tween.tween_property(%OmniLight3D, "light_energy", 1.0, 3.0)

	mouse_since_moved += delta

	if mouse_since_moved > mouse_stopped_move:
		angular_velocity = angular_velocity.lerp(Vector3.ZERO, 7.5 * delta)

	var directional_vel = Input.get_vector("left", "right", "up", "down")
	var vertical_direction = Input.get_axis("lower", "rise")
	var direction_vel_3 = Vector3(directional_vel.x, 0.0, directional_vel.y)

	var move_force = (to_global(direction_vel_3) - global_position) * speed
	var vertical_force = Vector3(0.0, vertical_direction * speed, 0.0)

	if awake:
		apply_force(move_force)
		apply_force(vertical_force)

	# Mouse capture toggle
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.mouse_mode

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and awake:
		mouse_since_moved = 0.0
		apply_torque(Vector3.UP * -event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity_vertical)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/3.5)
