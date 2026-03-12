class_name Power extends Node3D

signal power_lost

@export_custom(PROPERTY_HINT_NONE, "suffix:kwh") var max_capacity = 1500

@onready var remaining_capacity = max_capacity
@onready var prev_remaining_capacity = max_capacity

var discharge_rate
var is_good = true

func _physics_process(delta: float) -> void:
	discharge_rate = (prev_remaining_capacity - remaining_capacity) * delta
	
	prev_remaining_capacity = remaining_capacity
	
	if !has_capacity():
		power_lost.emit()

func has_capacity() -> bool:
	return remaining_capacity > 0.1 and is_good
