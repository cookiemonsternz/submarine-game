extends Node

@export var from_node: Node
@export var from_property: String
@export var to_node: Node
@export var to_property: String
@export var property_scale: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !from_node:
		from_node = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if property_scale != 0:
		to_node.set(to_property, from_node.get(from_property) * property_scale)
	else:
		to_node.set(to_property, from_node.get(from_property))
