class_name LookTarget extends Node3D

const CAMERA_GROUP = "player_camera"

@export var camera_position: Marker3D

@export_range(0.0, 5.0, 0.1) var tween_duration = 0.5

@export_group("Neighbours")
@export var left: LookTarget
@export var right: LookTarget
@export var up: LookTarget
@export var down: LookTarget

var focused = false

func _input(event: InputEvent) -> void:
	if not focused:
		return
	
	if event.is_action_pressed("left") && left:
		left.focus()
		focused = false
	if event.is_action_pressed("right") && right:
		right.focus()
		focused = false
	if event.is_action_pressed("up") && up:
		up.focus()
		focused = false
	if event.is_action_pressed("down") && down:
		down.focus()
		focused = false

func focus():
	var camera: Camera3D = get_tree().get_first_node_in_group(CAMERA_GROUP)
	
	var position_tween = get_tree().create_tween()
	var angle_tween = get_tree().create_tween()
	
	position_tween.set_trans(Tween.TRANS_QUAD)
	angle_tween.set_trans(Tween.TRANS_QUAD)
	
	# Hacky workaround so I don't have to do maths
	var dummy = Node3D.new()
	add_child(dummy)
	dummy.look_at_from_position(camera_position.global_position, global_position)
	var end_basis = dummy.global_basis
	dummy.queue_free()
	
	position_tween.tween_property(camera, "global_position", camera_position.global_position, tween_duration)
	angle_tween.tween_property(camera, "transform:basis", end_basis, tween_duration)
	
	position_tween.finished.connect(set_focused)

func set_focused(): 
	focused = true
