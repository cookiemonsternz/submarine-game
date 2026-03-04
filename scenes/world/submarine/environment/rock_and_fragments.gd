extends Node3D

@onready var fragments_first = $FragmentsFirst
@onready var fragments_second = $Fragments
@onready var rock = $RigidBody3D
@onready var rock_hitbox = $RockHitBox

var randomness :float = 0.4

func _on_rock_hit_box_area_entered(area: Area3D) -> void:
	if area.name == "Claw2":
		print("Test Complete")

func rock_destroy() -> void:
	print("rock destroying")
	for fragment in fragments_first.get_children():
		fragment.reparent(fragments_second)
		fragment.freeze = false
		fragment.apply_impulse(Vector3(randf_range(-randomness, randomness), randf_range(-randomness,randomness), randf_range(-randomness, randomness)))
	fragments_first.queue_free()
	rock.queue_free()
	rock_hitbox.queue_free()
