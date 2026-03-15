extends Node3D

signal pressed

var start = Vector3(0, 0, 0)
var end = Vector3(0, -0.025, 0);
var initial_pos = Vector3.ZERO;

@onready var button_sound := $AudioStreamPlayer

func _ready() -> void:
	initial_pos = position

func _on_mouse_target_pressed() -> void:
	pressed.emit()
	button_sound.play(0.0)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(%Mesh, "position", end, 0.1)


func _on_mouse_target_released() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(%Mesh, "position", start, 0.1)
