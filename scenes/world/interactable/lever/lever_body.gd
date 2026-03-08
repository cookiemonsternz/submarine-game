extends RigidBody3D

@export var boat: RigidBody3D

var dragging = false
var last_set_point: Vector3
var prev_linear_velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_set_point = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	pass
	#linear_velocity -= prev_linear_velocity
	#linear_velocity += boat.linear_velocity * 1.1
	
	#if dragging:
		#linear_velocity -= boat.linear_velocity
	
	#if !dragging:
		#global_position = boat.to_global(last_set_point)
	#
	#prev_linear_velocity = boat.linear_velocity

func _on_mouse_target_pressed():
	dragging = true

func _on_mouse_target_released():
	dragging = false
	last_set_point = boat.to_local(global_position)
