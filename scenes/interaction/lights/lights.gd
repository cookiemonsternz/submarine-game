extends Node3D

@export var tween_dur: float = 0.5

var prev_light_values = {}

@export var power: Power

@export var instr_lights: bool = true:
	get(): return instr_lights
	set(value):
		if instr_lights == value: return
		
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
@export var room_lights: bool = true:
	get(): return room_lights
	set(value):
		if room_lights == value: return
		
		if value:
			var lights = get_tree().get_nodes_in_group("sub_general_lights")
			for light: Light3D in lights:
				if !prev_light_values.has(light.name): continue
				var tween = get_tree().create_tween()
				tween.tween_property(light, "light_energy", prev_light_values[light.name], tween_dur)
		else:
			var lights = get_tree().get_nodes_in_group("sub_general_lights")
			for light: Light3D in lights:
				prev_light_values[light.name] = light.light_energy
				var tween = get_tree().create_tween()
				tween.tween_property(light, "light_energy", light.light_energy * 0.01, tween_dur)
		
		room_lights = value
@export var all_lights: bool = true

func _process(delta: float) -> void:
	if !power.has_capacity(): return
	
	if instr_lights:
		power.remaining_capacity -= 0.1 * delta
	if room_lights:
		power.remaining_capacity -= 0.1 * delta
