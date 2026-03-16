class_name AuxPropControlTarget extends Node3D

@export var boat: RigidBody3D

var dragging = false
var last_set_point: Vector3
var prev_linear_velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_set_point = global_position

func get_value() -> Vector2:
	var x = remap(self.position.x, -1, 1, 0, 1)
	var z = remap(self.position.z, -0.25, 0.25, 0, 1)
	return Vector2(x, z)

func _process(delta: float) -> void:
	position.y = 0
	
	position.x = clamp(position.x, -1, 1)
	position.z = clamp(position.z, -0.25, 0.25)
	
	if dragging:
		var camera: Camera3D = get_tree().get_first_node_in_group("player_camera")
		var plane := Plane(global_basis.y, global_position)
		var mouse_pos := get_viewport().get_mouse_position()
		var from := camera.project_ray_origin(mouse_pos)
		var pos = plane.intersects_ray(from, camera.project_ray_normal(mouse_pos) * 4096.0)
		if pos is Vector3:
			global_position = pos
		
	
	if !dragging:
		global_position = boat.to_global(last_set_point)
	
	prev_linear_velocity = boat.linear_velocity

func _on_mouse_target_pressed():
	dragging = true

func _on_mouse_target_released():
	dragging = false
	last_set_point = boat.to_local(global_position)
