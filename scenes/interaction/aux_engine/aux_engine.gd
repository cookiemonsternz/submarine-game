extends Node3D

@export var boat: RigidBody3D

@export var force: float = 0

func _physics_process(delta: float) -> void:
	boat.apply_force(global_basis.x * force * delta, global_position - boat.global_position)
