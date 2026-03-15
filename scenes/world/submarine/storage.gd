class_name MiniSubStorage extends Node3D

@export var storage: int = 20
var current_stored: int = 5
var is_full: bool = false

func _process(delta: float) -> void:
	for child in self.get_children():
		if current_stored < storage:
			pass
		else:
			is_full = true
			print("is full")
			

func add_ore(other_ore: StringName) -> void:
	current_stored += 1
	var new_node = Node3D.new()
	#new_node.name = str(other_ore) + str(randi())
	self.add_child(new_node)
