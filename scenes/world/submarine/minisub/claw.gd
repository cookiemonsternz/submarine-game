extends MeshInstance3D

@onready var targetObj = $"../Camera3D/Target"

var start_position: Vector3
var is_moving := false

func _ready() -> void:
	start_position = global_position


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and not is_moving:
		$Claw2.set_deferred("monitoring", true)
		claw_sequence()


func claw_sequence() -> void:
	is_moving = true
	
	var tween := create_tween()
	tween.tween_property(self, "position", get_parent().to_local(targetObj.global_position), 0.3)
	await tween.finished
	
	print("Reached")
	
	
	var tween_back := create_tween()
	tween_back.tween_property(self, "position", start_position, 0.3)
	await tween_back.finished
	
	is_moving = false
	
	
func _on_claw_2_area_entered(area: Area3D) -> void:
	if area.is_in_group("grabbable") and is_instance_valid(area):
		
		var saved_transform = area.global_transform
		
		area.reparent(self)
		area.global_transform = saved_transform
		
		await get_tree().create_timer(0.3).timeout
		if is_instance_valid(area):
			area.queue_free()
