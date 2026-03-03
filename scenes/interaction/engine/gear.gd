class_name Gear extends Resource

@export var water_coefficient: float
@export var max_torque: float
@export var gear_ratio: float

func _init(p_water_coefficient = 0, p_max_torque = 0, p_gear_ratio = 0):
	water_coefficient = p_water_coefficient
	max_torque = p_max_torque
	gear_ratio = p_gear_ratio
