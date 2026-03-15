extends Node3D


var start = Vector3(0.05, 2.75, 0.0);
var end = Vector3(0.05, 0.45, 0.0);

func _on_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.finished.connect(reset)
	tween.tween_property(%Piston, "position", end, 2.0)
	
	var light_tween = get_tree().create_tween()
	light_tween.finished.connect(light_reset);
	tween.tween_property(%SpotLight3D, "light_color", Color(0.808, 0.0, 0.19, 1.0), 0.5)

func reset():
	await get_tree().create_timer(1.0).timeout
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(%Piston, "position", start, 3.0)

func light_reset():
	await get_tree().create_timer(2.5).timeout
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(%SpotLight3D, "light_color", Color(0.679, 0.654, 0.626, 1.0), 0.5)
