extends Node3D

# Throttle maps to power
# Power maps to applied force to drivechain (simmed)
# RPM maps via gear to force applied to boat

# Throttle -> Engine Torque
# Engine Torque -> Through Gear -> Prop Torque
# Prop RPM -> Water Resistance (RPM ^ 2)
# Water Resistance -> Reflected Load -> Engine
# Engine Torque - Load -> RPM acceleration

@export var boat: RigidBody3D
@export var engine_pos: Marker3D

@export_category("Motor")

@export_range(0.0, 1.0, 0.01, "prefer_slider") var throttle: float = 0.0

@export_group("Power")
@export_custom(PROPERTY_HINT_NONE, "suffix:nm") var min_torque: float = 0
@export_custom(PROPERTY_HINT_NONE, "suffix:nm") var max_torque: float = 50000
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
@export_group("Gears")
@export var gears: Array[Gear]
@export var gear: int = 0

var engine_rpm = 0
var prop_rpm = 0
@onready var temp = ambient_temp

func _physics_process(delta: float) -> void:
	var current_gear = gears[gear]
	
	var engine_torque = lerp(min_torque, max_torque, throttle)
	var prop_load = current_gear.water_coefficient * (prop_rpm ** 2)
	
	var effective_prop_inertia = prop_mass * current_gear.gear_ratio ** 2
	var engine_load = prop_load / current_gear.gear_ratio
	
	var net_inertia = engine_mass + effective_prop_inertia
	var friction_torque = engine_friction_coefficient * engine_rpm if throttle < 0.1 else 0.0
	var net_torque = engine_torque - engine_load - friction_torque
	var alpha = net_torque / net_inertia
	engine_rpm += alpha * 60.0 / (2 * PI) * delta
	engine_rpm = max(min_rpm, engine_rpm)
	prop_rpm = engine_rpm / current_gear.gear_ratio
	
	var power_heat = power_heat_scale * abs(engine_torque) * 0.0001
	var temp_delta = power_heat * delta - power_dissipation_scale * 0.05 * (temp - ambient_temp) * delta
	temp += temp_delta
	
	print(engine_rpm, " : ", prop_rpm, " : ", snapped(temp, 0.01))
	
	boat.apply_force(engine_pos.global_basis.z * prop_rpm * rpm_force_ratio, boat.global_position - engine_pos.global_position)
