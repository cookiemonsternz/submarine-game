@tool
extends Node3D

@export var state: bool = false:
	get(): return state
	set(value):
		match value:
			true: 
				%switch.rotation_degrees.z = 0
			false: 
				%switch.rotation_degrees.z = 95
		state = value
		
		if Engine.is_editor_hint(): return
		if !node: return
		if !property: return
		node.set(property, value)

@export var node: Node3D
@export var property: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set("state", state)
	pass

func _on_mouse_target_pressed() -> void:
	state = !state


func _on_mouse_target_released() -> void:
	pass # Replace with function body.


func _on_mouse_target_hovered() -> void:
	pass # Replace with function body.


func _on_mouse_target_unhovered() -> void:
	pass # Replace with function body.

func set_true() -> void:
	state = true

func set_false() -> void:
	state = false
