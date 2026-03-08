extends Node3D

@export var tween_dur: float = 0.5

var prev_light_values = {}

@export var instr_lights: bool = true:
	get(): return instr_lights
	set(value):
		if value:
			var lights = get_tree().get_nodes_in_group("sub_instr_lights")
			for light: Light3D in lights:
				var tween = get_tree().create_tween()
				tween.tween_property(light, "light_energy", prev_light_values[light.name], tween_dur)
		else:
			var lights = get_tree().get_nodes_in_group("sub_instr_lights")
			for light: Light3D in lights:
				prev_light_values[light.name] = light.light_energy
				var tween = get_tree().create_tween()
				tween.tween_property(light, "light_energy", light.light_energy * 0.01, tween_dur)
		instr_lights = value
@export var room_lights: bool = false
@export var all_lights: bool = true
