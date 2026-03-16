class_name Measureable extends Node3D

@export var drag_body: RigidBody3D
@export var joint: Joint3D

func get_value() -> float:
	if joint is SliderJoint3D and drag_body is SliderBody:
		var start = joint.global_position + joint.global_basis.x * -0.15
		var end = joint.global_position + joint.global_basis.x * 0.15
		var length = (end - start).length()
		return (start - drag_body.global_position).length() / length
	elif joint is SliderJoint3D:
		var start = joint.global_position + joint.global_basis.x * 0.0
		var end = joint.global_position + joint.global_basis.x * 2.25
		var length = (end - start).length()
		return (start - drag_body.global_position).length() / length
	elif joint is HingeJoint3D and drag_body is Wheel:
		var angle = rad_to_deg(drag_body.rotation.y)
		#var lower = rad_to_deg(joint.PARAM_LIMIT_LOWER)
		#var upper = rad_to_deg(joint.PARAM_LIMIT_UPPER)
		#print(angle, " : ", lower, " : ", upper)
		return clamp(inverse_lerp(-140, 140, angle), 0.0, 1.0)
	elif joint is HingeJoint3D:
		var hinge_axis: Vector3 = joint.global_basis.z
		var reference: Vector3 = joint.global_basis.x
		var body_dir: Vector3 = drag_body.global_basis.y
		
		var angle = -rad_to_deg(reference.signed_angle_to(body_dir, hinge_axis))
		
		#var lower = rad_to_deg(joint.PARAM_LIMIT_LOWER)
		#var upper = rad_to_deg(joint.PARAM_LIMIT_UPPER)
		
		#print(clamp(inverse_lerp(lower, upper, angle), 0.0, 1.0))

		return clamp(inverse_lerp(-40, 40, angle), 0.0, 1.0)
	elif joint is ConeTwistJoint3D:
		assert(false, "Not implemented")
		return 0.0
	assert(false, "Unsupported joint type")
	return 0.0
