extends Area3D

@onready var other_pos:Area3D = $"../MiniSubExitArea"
@onready var extereor_hitbox:CollisionShape3D = $"../../MiniSubCollisions/Extereor"
var is_inside := true

func _process(delta: float) -> void:
	print(is_inside)

func _on_area_entered(area: Area3D) -> void:
	print(area.name)
	print("area entered")
	if area.name == "MiniSubHitbox":
		print("its the mini sub")
		is_inside = false
		area.get_parent_node_3d().global_position = other_pos.global_position
		area.get_parent_node_3d().is_tracking = false
		extereor_hitbox.disabled = false
