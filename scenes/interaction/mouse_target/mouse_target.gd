class_name MouseTarget extends Area3D

signal pressed
signal released

@export var outline_objects: Array[GeometryInstance3D]
@export var enabled: bool = true

@export var selectable: bool = false

var hovered = false

var is_pressed = false:
	get: return is_pressed
	set(value):
		is_pressed = value
		if value == false && !hovered:
			for outline_object in outline_objects:
				outline_object.set_layer_mask_value(11, false)

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
	
	hovered = true
	
	for outline_object in outline_objects:
		outline_object.set_layer_mask_value(11, true)

func _on_mouse_exited() -> void:
	if is_pressed: return
	
	hovered = false
	
	for outline_object in outline_objects:
		outline_object.set_layer_mask_value(11, false)

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false
	for outline_object in outline_objects:
		outline_object.set_layer_mask_value(11, false)
