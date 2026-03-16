extends MeshInstance3D

func _process(delta: float) -> void:
	var sub_position = get_tree().get_first_node_in_group("submarine").global_position
	var target_position = get_tree().get_first_node_in_group("story_target").global_position
	
	var direction: Vector3 = sub_position - target_position
	
	if direction.length() < 400.0: hide()
	else: show()
	
	position = to_local(direction).normalized() * 0.9
	position.y = 1
