extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is DraggableOre:
		body.start_cook_timer()

func _physics_process(delta: float) -> void:
	#print(%AudioStreamPlayer3D.volume_linear)
	
	var value = $RigidBody3D/Measureable.get_value()
	%AudioStreamPlayer3D.volume_linear = (value / 1.2) - 0.6
