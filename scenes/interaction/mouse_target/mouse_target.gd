class_name MouseTarget extends Area3D

signal pressed
signal released

@export var outline_object: GeometryInstance3D
@export var enabled: bool = true

@export var selectable: bool = false

var is_pressed = false

func _input(event: InputEvent) -> void:
	if !selectable: return
	if !enabled: return
	
	if event.is_action_pressed("select"):
		pressed.emit()
		is_pressed = true
	
	if event.is_action_released("select"):
		released.emit()
		is_pressed = false

func _on_mouse_entered() -> void:
	if !enabled: return
	outline_object.set_layer_mask_value(11, true)

func _on_mouse_exited() -> void:
	outline_object.set_layer_mask_value(11, false)

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false
	outline_object.set_layer_mask_value(11, false)
