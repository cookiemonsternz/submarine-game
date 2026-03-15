class_name Player extends CharacterBody3D

@export var speed = 5
@export var jump_velocity = 3

@onready var camera:Camera3D = $Camera3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity = ProjectSettings.get_setting("player/look_sensitivity")

var vel_y = 0

var awake = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Show outline effect on game start
	$HighlightViewport/HighlightCamera3D/HighlightEffectDepth.show()
	$Camera3D/HighlightEffect.show()

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("mini_sub"):
		if awake == true:
			awake = false
			camera.current = false
			$HighlightViewport/HighlightCamera3D/HighlightEffectDepth.hide()
			var mat: ShaderMaterial = $Camera3D/HighlightEffect.get_active_material(0)
			mat.set_shader_parameter("highlight_enabled", false);
			mat.set_shader_parameter("sobel_enabled", true);
			mat.set_shader_parameter("pixelate_enabled", true);
			mat.set_shader_parameter("steps_l", 36);
			
			get_tree().get_first_node_in_group("kelp").show()
			
		elif awake == false:
			awake = true
			camera.current = true
			var mat: ShaderMaterial = $Camera3D/HighlightEffect.get_active_material(0)
			mat.set_shader_parameter("highlight_enabled", true);
			mat.set_shader_parameter("sobel_enabled", false);
			mat.set_shader_parameter("pixelate_enabled", false);
			mat.set_shader_parameter("steps_l", 12);
			$HighlightViewport/HighlightCamera3D/HighlightEffectDepth.show()
			get_tree().get_first_node_in_group("kelp").hide()
			#$Camera3D/HighlightEffect.show()
	
	if Engine.is_editor_hint():
		$HighlightViewport/HighlightCamera3D/HighlightEffectDepth.hide()
		$Camera3D/HighlightEffect.hide()
		return
	
	var horizontal_vel = Input.get_vector("left", "right", "up", "down").normalized()
	if awake:
		velocity = (horizontal_vel.x * global_transform.basis.x + horizontal_vel.y * global_transform.basis.z) * speed
	else:
		velocity = Vector3(0,0,0)
	
	if is_on_floor():
		vel_y = 0
		#print("Touching floor")
		if Input.is_action_just_pressed("jump"): vel_y = jump_velocity
	else:
		vel_y -= gravity * delta
	
	velocity.y = vel_y
	
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_cancel"): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		
func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	if event.is_action_pressed("zoom"):
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property($Camera3D, "fov", 40, 0.25)
		
		var tween2 = get_tree().create_tween()
		tween2.set_trans(Tween.TRANS_QUAD)
		tween2.tween_property($HighlightViewport/HighlightCamera3D, "fov", 40, 0.25)
	
	if event.is_action_released("zoom"):
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property($Camera3D, "fov", 75, 0.25)
		
		var tween2 = get_tree().create_tween()
		tween2.set_trans(Tween.TRANS_QUAD)
		tween2.tween_property($HighlightViewport/HighlightCamera3D, "fov", 75, 0.25)
