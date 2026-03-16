extends Area3D

@onready var other_pos:MeshInstance3D = $"../MiniSubDockPos"
@onready var extereor_hitbox:CollisionShape3D = $"../../MiniSubCollisions/Extereor"
@onready var mini_sub_entry = $"../MiniSubEntryArea"

func _on_area_entered(area: Area3D) -> void:
	#print(area.name)
	#print("area entered")
	if area.name == "MiniSubHitbox":
		$"../MiniSubEntryArea".is_inside = true
		%DockUndockAudio.play(5.73);
		#print("its the mini sub")
		extereor_hitbox.set_deferred("disabled", true)
		area.get_parent_node_3d().global_position = other_pos.global_position
		area.get_parent_node_3d().rotation_degrees.y = 0
		area.get_parent_node_3d().is_tracking = true
		
		var music_bus = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_send(music_bus, "UnderwaterMusic")
