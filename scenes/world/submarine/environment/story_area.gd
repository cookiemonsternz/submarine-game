extends Area3D

func _on_body_entered(body: Node3D) -> void:
	get_tree().get_first_node_in_group("main").found_first_mineral()
