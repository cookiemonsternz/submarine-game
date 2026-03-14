extends Node3D

@export var power_count: int = 180



func _process(delta: float) -> void:
	pass

func decrease_oxygen() -> void:
	power_count -= 1
	print(power_count)


func _on_timer_timeout() -> void:
	decrease_oxygen()
