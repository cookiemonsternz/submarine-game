extends Node3D

@export var boat: RigidBody3D
@export var power: Power

@export var force: float = 0

func _physics_process(delta: float) -> void:
	power.remaining_capacity -= force / 160000000
	boat.apply_force(global_basis.x * -force * delta, global_position - boat.global_position)
