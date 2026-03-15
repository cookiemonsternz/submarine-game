extends Node3D

# Throttle maps to power
# Power maps to applied force to drivechain (simmed)
# RPM maps via gear to force applied to boat

# Throttle -> Engine Torque
# Engine Torque -> Through Gear -> Prop Torque
# Prop RPM -> Water Resistance (RPM ^ 2)
# Water Resistance -> Reflected Load -> Engine
# Engine Torque - Load -> RPM acceleration

signal engine_fuse_blown
signal coolant_pump_fuse_blown

@export var boat: RigidBody3D
@export var power: Power
@export var engine_pos: Marker3D
@export var engine_audio_player: AudioStreamPlayer3D

@export_category("Motor")

@export_range(0.0, 1.0, 0.01, "prefer_slider") var throttle: float = 0.0

@export_group("Power")
@export_custom(PROPERTY_HINT_NONE, "suffix:nm") var min_torque: float = 0
@export_group("RPM")
@export_custom(PROPERTY_HINT_NONE, "suffix:RPM") var min_rpm: float = 0
@export_custom(PROPERTY_HINT_NONE, "suffix:RPM") var max_rpm: float = 1800
@export_group("Drive Chain")
@export_custom(PROPERTY_HINT_NONE, "suffix:kg") var engine_mass: float = 3000
@export_custom(PROPERTY_HINT_NONE, "suffix:kg") var prop_mass: float = 500
@export var engine_friction_coefficient: float = 10000
@export var torque_scale = 1.0
@export var rpm_force_ratio = 100.0
@export_group("Temps")
@export_custom(PROPERTY_HINT_NONE, "suffix:°C") var max_temp: float = 120
@export var ambient_temp = 25.0
@export var power_heat_scale: float = 1.0
@export var power_dissipation_scale: float = 1.0
@export var coolant_pump_max_power: float = 0.00125
@export_group("Gears")
@export var gears: Array[Gear]
@export var gear: int = 0
@export var mode: int = 2 # 0 - reverse, 1 - neutral, 2 - forward

var engine_rpm = 0
var prop_rpm = 0
var coolant_power = 0
var is_engine_good = true
var is_coolant_good = true
var desired_coolant_scale = 0.0
@onready var temp = ambient_temp

func _physics_process(delta: float) -> void:	
	var current_gear = gears[gear]
	
	var engine_torque = lerp(min_torque, current_gear.max_torque, throttle)
	if !is_engine_good: engine_torque = 0
	var prop_load = current_gear.water_coefficient * (prop_rpm ** 2)
	
	var effective_prop_inertia = prop_mass * current_gear.gear_ratio ** 2
	var engine_load = prop_load / current_gear.gear_ratio if is_engine_good else 800
	
	if !is_engine_good: engine_load *= 500
	if mode == 1 and is_engine_good: engine_load *= 0.05
	
	#print(engine_load)
	
	var net_inertia = engine_mass + effective_prop_inertia
	var friction_torque = engine_friction_coefficient * engine_rpm if throttle < 0.1 else 0.0
	var net_torque = engine_torque - engine_load - friction_torque
	var alpha = net_torque / net_inertia
	
	engine_rpm += alpha * 60.0 / (2 * PI) * delta
	engine_rpm = max(min_rpm, engine_rpm)
	if mode == 1:
		prop_rpm = 0
	else:
		prop_rpm = engine_rpm / current_gear.gear_ratio
	
	var power_heat = power_heat_scale * abs(engine_torque) * 0.0001 * gear
	var temp_delta = power_heat * delta - power_dissipation_scale * 0.05 * (temp - ambient_temp) * delta
	temp += temp_delta
	
	if temp > max_temp or engine_rpm > max_rpm:
		is_engine_good = false
		engine_fuse_blown.emit()
	
	if power.has_capacity() and is_engine_good:
		power.remaining_capacity -= ((engine_torque * engine_rpm * 2 * PI) / (60 * 1000 * 3600)) * delta
	if is_coolant_good:
		power_dissipation_scale = desired_coolant_scale
		coolant_power = (power_dissipation_scale * engine_rpm / 36000) * delta
	else:
		coolant_power = 0
		power_dissipation_scale = 0.25
	if power.has_capacity() and is_coolant_good:
		power.remaining_capacity -= coolant_power
	
	# ENGINE AUDIO
	engine_audio_player.pitch_scale = engine_rpm / 800;
	
	if coolant_power > coolant_pump_max_power:
		is_coolant_good = false
		
		coolant_pump_fuse_blown.emit()
	
	if mode == 1: return
	
	if mode == 2:
		boat.apply_force(engine_pos.global_basis.z * prop_rpm * rpm_force_ratio, boat.global_position - engine_pos.global_position)
		return
	
	if mode == 0:
		boat.apply_force(-engine_pos.global_basis.z * prop_rpm * rpm_force_ratio, boat.global_position - engine_pos.global_position)
		return
