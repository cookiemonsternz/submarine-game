class_name Draggable extends Node3D

@export var drag_strength: float = 500.0
@export var scroll_strength: float = 5.0

@export var rigidbody: RigidBody3D
@export var mouse_target: MouseTarget

var dragging = false
var hovered = false

func _ready() -> void:
	mouse_target.pressed.connect(_on_mouse_target_pressed)
	mouse_target.released.connect(_on_mouse_target_released)
	mouse_target.hovered.connect(_on_mouse_target_hovered)
	mouse_target.unhovered.connect(_on_mouse_target_unhovered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		if rigidbody is AuxPropControlTarget:
			var camera: Camera3D = get_tree().get_first_node_in_group("player_camera")
			#var plane := Plane(camera.global_basis.z, rigidbody.global_position)
			var plane := Plane(rigidbody.global_basis.y, rigidbody.global_position)
			var mouse_pos := get_viewport().get_mouse_position()
			var from := camera.project_ray_origin(mouse_pos)
			var pos = plane.intersects_ray(from, camera.project_ray_normal(mouse_pos) * 4096.0)
			if pos is Vector3:
				var vec = (pos - rigidbody.global_position)
				#var vec_len = vec.length()
				vec = (vec) * drag_strength
				rigidbody.apply_force(vec * delta, pos - rigidbody.global_position)
		elif rigidbody is Wheel:
			var camera: Camera3D = get_tree().get_first_node_in_group("player_camera")
			#var plane := Plane(camera.global_basis.z, rigidbody.global_position)
			var plane := Plane(rigidbody.global_basis.y, rigidbody.global_position)
			var mouse_pos := get_viewport().get_mouse_position()
			var from := camera.project_ray_origin(mouse_pos)
			var pos = plane.intersects_ray(from, camera.project_ray_normal(mouse_pos) * 4096.0)
			if pos is Vector3:
				var vec = (pos - rigidbody.global_position)
				var vec_len = vec.length()
				vec = (vec / vec_len) * drag_strength
				rigidbody.apply_force(vec * delta, pos - rigidbody.global_position)
		elif rigidbody is RigidBody3D:
			var camera: Camera3D = get_tree().get_first_node_in_group("player_camera")
			var plane := Plane(camera.global_basis.z, rigidbody.global_position)
			#var plane := Plane(rigidbody.global_basis.y, rigidbody.global_position)
			var mouse_pos := get_viewport().get_mouse_position()
			var from := camera.project_ray_origin(mouse_pos)
			var pos = plane.intersects_ray(from, camera.project_ray_normal(mouse_pos) * 4096.0)
			if pos is Vector3:
				var vec = (pos - rigidbody.global_position)
				var vec_len = vec.length()
				vec = (vec / vec_len) * drag_strength
				rigidbody.apply_central_force(vec * delta)

func _input(event: InputEvent) -> void:
	if !hovered: return
	
	if Input.is_action_just_pressed("control_increase"):
		rigidbody.apply_central_force(rigidbody.global_basis.x * scroll_strength)
	if Input.is_action_just_pressed("control_decrease"):
		rigidbody.apply_central_force(-rigidbody.global_basis.x * scroll_strength)

func _on_mouse_target_pressed() -> void:
	dragging = true

func _on_mouse_target_released() -> void:
	dragging = false

func _on_mouse_target_hovered() -> void:
	hovered = true

func _on_mouse_target_unhovered() -> void:
	hovered = false
