extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var value: Vector2 = $Target.get_value()
	var posX = remap(value.x, 0.2, 0.67, 681, 1663)
	var posY = remap(value.y, 0, 1, 189, 320)
	
	if value.y < 0.6 and value.y > 0.4:
		$SubViewport/Particles/LeftForwardParticles.amount_ratio = 0
		$SubViewport/Particles/LeftRearParticles.amount_ratio = 0
		$SubViewport/Particles/RightForwardParticles.amount_ratio = 0
		$SubViewport/Particles/RightRearParticles.amount_ratio = 0
		return
	
	if value.y < 0.5:
		$SubViewport/Particles/LeftForwardParticles.amount_ratio = 0
		$SubViewport/Particles/LeftRearParticles.amount_ratio = 0
		
		var dist_forward = abs(posX - $SubViewport/Particles/RightForwardParticles.position.x)
		var dist_rear = abs(posX - $SubViewport/Particles/RightRearParticles.position.x)
		var sum = dist_forward + dist_rear
		
		$SubViewport/Particles/RightForwardParticles.amount_ratio = dist_forward / sum
		$SubViewport/Particles/RightRearParticles.amount_ratio = dist_rear / sum
	elif value.y > 0.5:
		$SubViewport/Particles/RightForwardParticles.amount_ratio = 0
		$SubViewport/Particles/RightRearParticles.amount_ratio = 0
		
		var dist_forward = abs(posX - $SubViewport/Particles/LeftForwardParticles.position.x)
		var dist_rear = abs(posX - $SubViewport/Particles/LeftRearParticles.position.x)
		var sum = dist_forward + dist_rear
		$SubViewport/Particles/LeftForwardParticles.amount_ratio = dist_forward / sum
		$SubViewport/Particles/LeftRearParticles.amount_ratio = dist_rear / sum
