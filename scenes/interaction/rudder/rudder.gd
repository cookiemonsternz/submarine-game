extends Node3D

@export var boat: RigidBody3D

@export_custom(PROPERTY_HINT_NONE, "suffix:m") var size: Vector2 = Vector2(4, 4)
@export var angle: float = 0.0
@export var force_scale: float = 1000.0

func _physics_process(delta: float) -> void:
	var area = size.x * size.y
	
	var vel_impact = boat.to_global(boat.linear_velocity).dot(Vector3.FORWARD)
	
	var force = area * angle * force_scale * vel_impact * delta
	if angle > 0:
		boat.apply_torque(Vector3.UP * force)
	else:
		boat.apply_torque(Vector3.DOWN * force)
