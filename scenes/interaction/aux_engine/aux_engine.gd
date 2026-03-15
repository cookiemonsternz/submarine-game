extends Node3D

@export var boat: RigidBody3D
@export var aux_props_control: AuxPropsControl
@export var audio_player: AudioStreamPlayer3D
@export var power: Power

@export var force: float = 0

func _physics_process(delta: float) -> void:
	if !aux_props_control.is_good: return
	
	if power.has_capacity():
		power.remaining_capacity -= force / 160000000
		if not audio_player.playing && force > 10:
			audio_player.play()
		
		if audio_player.playing && force < 10:
			audio_player.stop()
		
		if audio_player.playing:
			audio_player.pitch_scale = force / 500000.0
	else:
		if audio_player.playing:
			audio_player.stop()
	boat.apply_force(global_basis.x * -force * delta, global_position - boat.global_position)
