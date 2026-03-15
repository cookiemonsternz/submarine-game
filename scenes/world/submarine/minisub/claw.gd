extends MeshInstance3D

@onready var targetObj = $"../Camera3D/Target"


var rigid_grab = false
var start_position: Vector3
var is_moving := false

func _ready() -> void:
	start_position = global_position


func _process(delta: float) -> void:
	for child in self.get_children():
		if child is RigidBody3D:
			
			child.freeze = true
			child.global_position = self.global_position
	
	
	if Input.is_action_just_pressed("click") and not is_moving and %MiniSub.awake:
		$Claw2.set_deferred("monitoring", true)
		claw_sequence()


func claw_sequence() -> void:
	is_moving = true
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "position", get_parent().to_local(targetObj.global_position), 0.9)
	await tween.finished
	
	#print("Reached")
	
	
	var tween_back := create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween_back.tween_property(self, "position", start_position, 0.9)
	await tween_back.finished
	
	is_moving = false
	
	
func _on_claw_2_area_entered(area: Area3D) -> void:
	if area.is_in_group("grabbable") and is_instance_valid(area) and area.get_parent().get_parent() != self:
		#print(area.get_parent().get_parent().name, " : ", area.get_parent().name)
		
		%"Storage".add_ore(area.name)
		area.get_parent().reparent(self)
		rigid_grab = true
		
		await get_tree().create_timer(1.5).timeout
		
		area.get_parent().queue_free()
