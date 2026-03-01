class_name Draggable extends Node3D

@export var drag_strength: float = 500.0

@export var rigidbody: RigidBody3D
@export var mouse_target: MouseTarget

var dragging = false

func _ready() -> void:
	mouse_target.pressed.connect(_on_mouse_target_pressed)
	mouse_target.released.connect(_on_mouse_target_released)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		var camera: Camera3D = get_tree().get_first_node_in_group("player_camera")
		var plane := Plane(camera.global_basis.z, rigidbody.global_position)
		var mouse_pos := get_viewport().get_mouse_position()
		var from := camera.project_ray_origin(mouse_pos)
		var pos = plane.intersects_ray(from, camera.project_ray_normal(mouse_pos) * 4096.0)
		if pos is Vector3:
			#print((global_position - pos).normalized() * -1.0)
			var vec = (pos - rigidbody.global_position)
			var vec_len = vec.length()
			vec = (vec / vec_len) * drag_strength
			rigidbody.apply_central_force(vec * delta)

func _on_mouse_target_pressed() -> void:
	dragging = true

func _on_mouse_target_released() -> void:
	dragging = false
