extends Area3D

@onready var other_pos:MeshInstance3D = $"../MiniSubDockPos"
@onready var extereor_hitbox:CollisionShape3D = $"../../MiniSubCollisions/Extereor"
@onready var mini_sub_entry = $"../MiniSubEntryArea"

func _on_area_entered(area: Area3D) -> void:
	#print(area.name)
	#print("area entered")
	if area.name == "MiniSubHitbox":
		$"../MiniSubEntryArea".is_inside = true
		#print("its the mini sub")
		extereor_hitbox.disabled = true
		area.get_parent_node_3d().global_position = other_pos.global_position
		area.get_parent_node_3d().rotation_degrees.y = 0
		area.get_parent_node_3d().is_tracking = true
