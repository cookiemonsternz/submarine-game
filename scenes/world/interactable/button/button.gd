extends Node3D

signal pressed

var start = Vector3(0, 0, 0)
var end = Vector3(0, 0.1, 0);

func _on_mouse_target_pressed() -> void:
	pressed.emit()
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(%Mesh, "position", end, 1.0)


func _on_mouse_target_released() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(%Mesh, "position", end, 1.0)
