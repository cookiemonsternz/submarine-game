class_name measureable extends Node3D

@export var drag_body: RigidBody3D
@export var joint: JoltJoint3D

func get_value() -> float:
	if joint is JoltSliderJoint3D:
		var start = joint.global_position + joint.global_basis.x * joint.limit_lower
		var end = joint.global_position + joint.global_basis.x * joint.limit_upper
		var len_sq = (end - start).length_squared()
		return (start - drag_body.global_position).length_squared() / len_sq
	elif joint is JoltHingeJoint3D:
		var hinge_axis: Vector3 = joint.global_basis.z
		var reference: Vector3 = joint.global_basis.x
		var body_dir: Vector3 = drag_body.global_basis.y
		
		var angle = -rad_to_deg(reference.signed_angle_to(body_dir, hinge_axis))
		
		var lower = rad_to_deg(joint.limit_lower)
		var upper = rad_to_deg(joint.limit_upper)

		return clamp(inverse_lerp(lower, upper, angle), 0.0, 1.0)
	elif joint is JoltConeTwistJoint3D:
		assert(false, "Not implemented")
		return 0.0
	assert(false, "Unsupported joint type")
	return 0.0

func _process(delta: float) -> void:
	get_value()
