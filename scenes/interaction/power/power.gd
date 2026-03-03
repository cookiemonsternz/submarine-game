class_name Power extends Node3D

@export_custom(PROPERTY_HINT_NONE, "suffix:kwh") var max_capacity = 1500

@onready var remaining_capacity = max_capacity
@onready var prev_remaining_capacity = max_capacity

var discharge_rate

func _physics_process(delta: float) -> void:
	discharge_rate = (remaining_capacity - prev_remaining_capacity) * delta
	
	prev_remaining_capacity = remaining_capacity
