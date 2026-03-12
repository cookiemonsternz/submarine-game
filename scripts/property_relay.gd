extends Node3D

@export var from_min: float
@export var from_max: float
@export var to_min: float
@export var to_max: float
@export var node: Node3D
@export var property: String

var value: float:
	get(): return value
	set(new):
		value = new
		node.set(property, remap(new, from_min, from_max, to_min, to_max))
