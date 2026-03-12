extends Node

@export var target: Node
@export var from: Array[Node]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in from:
		node.reparent(target)
