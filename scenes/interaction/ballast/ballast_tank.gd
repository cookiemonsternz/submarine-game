@tool
class_name BallastTank extends CollisionShape3D

@export_custom(PROPERTY_HINT_NONE, "suffix: l/s") var flood_rate: float = 3000
@export_custom(PROPERTY_HINT_NONE, "suffix: l/s") var pump_rate: float = 1000

@export_group("PID")
@export var p: float = 0.1
@export var i: float = 0.1
@export var d: float = 0.1

var pid = {
	"prev_error": 0,
	"integral": 0
}

@export_group("")
@export var ratio = 0.0
@export var desired_ratio = 0.0

var volume = 0.0
var water_volume = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		shape = BoxShape3D.new()
	
	var box: BoxShape3D = shape
	volume = box.size.x * box.size.y * box.size.z
	water_volume = volume * ratio

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var error = desired_ratio - ratio
	
	var p_term = p * error
	
	pid["integral"] += error * delta
	var i_term = i * pid["integral"]
	
	var derivative = (error - pid["prev_error"]) / delta
	var d_term = d * derivative
	
	var u = p_term + i_term + d_term
	u = clamp(u, -1, 1)
	
	if u > 0:
		water_volume += (u * flood_rate) / 1000
	else:
		water_volume += (u * pump_rate) / 1000
	
	water_volume = clamp(water_volume, 0, volume)
	
	ratio = water_volume / volume
