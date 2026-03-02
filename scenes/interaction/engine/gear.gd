class_name Gear extends Resource

@export var water_coefficient: float
@export var gear_ratio: float

func _init(p_gear_ratio = 0):
	gear_ratio = p_gear_ratio
