extends RigidBody3D

var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		var camera: Camera3D = get_tree().get_first_node_in_group("player_camera")
		var plane := Plane(camera.global_basis.z, global_position)
		var mouse_pos := get_viewport().get_mouse_position()
		var from := camera.project_ray_origin(mouse_pos)
		var pos = plane.intersects_ray(from, camera.project_ray_normal(mouse_pos) * 4096.0)
		if pos is Vector3:
			#print((global_position - pos).normalized() * -1.0)
			var vec = (pos - global_position).normalized() * 5
			apply_central_force(vec)
		


func _on_mouse_target_pressed() -> void:
	dragging = true


func _on_mouse_target_released() -> void:
	dragging = false
