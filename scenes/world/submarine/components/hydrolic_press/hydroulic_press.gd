extends Node3D

@export var money: Money

var start = Vector3(0.05, 2.75, 0.0);
var end = Vector3(0.05, 0.45, 0.0);

func _on_button_pressed() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.finished.connect(reset)
	tween.tween_property(%Piston, "position", end, 2.0)
	tween.set_parallel()
	
	var light_tween = create_tween()
	light_tween.tween_property(%SpotLight3D, "light_color", Color(0.808, 0.0, 0.19, 1.0), 0.5)
	
	get_tree().create_timer(1.5).timeout.connect(enable_collisions)

func reset():
	get_tree().create_timer(1.0).timeout.connect(redo_press)
	

func redo_press():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(%Piston, "position", start, 3.0)
	tween.set_parallel()
	
	var light_tween = create_tween()
	light_tween.set_ease(Tween.EASE_IN)
	light_tween.set_trans(Tween.TRANS_LINEAR)
	light_tween.tween_property(%SpotLight3D, "light_color", Color(0.679, 0.654, 0.626, 1.0), 0.5)
	
	%Area3D.monitoring = false

func enable_collisions():
	%Area3D.monitoring = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is DraggableOre:
		print("HI")
		
		if !body.cooked: return;
		
		money.money += money.money_per_ore
		
		%GPUParticles3D.restart()
		
		body.queue_free()
