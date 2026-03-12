class_name Ballast extends Node3D

@export var boat: RigidBody3D

@export_custom(PROPERTY_HINT_NONE, "suffix:kg/l") var air_bouyancy = 1.0
@export_custom(PROPERTY_HINT_NONE, "suffix: kg/l") var water_mass = 1.0
@export var force_scale = 10

var tanks: Array[BallastTank] = []
var power_draw = 0.0
var is_good = true

func _ready() -> void:
	get_tanks()

func _physics_process(delta: float) -> void:	
	power_draw = 0.0
	for tank in tanks:
		power_draw += tank.power_draw
		
		var pos = tank.global_position
		var water_force = tank.water_volume * water_mass * 1000
		var air_force = (tank.volume - tank.water_volume) * air_bouyancy * 1000
		var net_force = Vector3.DOWN * water_force + Vector3.UP * air_force
		net_force *= force_scale
		
		boat.apply_force(net_force * delta, boat.global_position - pos)

func get_tanks():
	var children = get_children()
	tanks = []
	
	for child in children:
		if child is BallastTank:
			tanks.push_back(child)
