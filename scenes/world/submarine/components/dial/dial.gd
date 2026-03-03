extends Node3D

@export var node: Node
@export var property: String

@export var min_value: float = 0.0
@export var max_value: float = 0.0

@export var dial_speed = 2

@export_category("PID")
@export var p: float = 0.05
@export var i: float = 0.01
@export var d: float = 0

var pid = {
	"prev_error": 0,
	"integral": 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var target_value = node.get(property)
	
	var target_weight = remap(target_value, min_value, max_value, 0, 1)
	var target_angle = remap(target_weight, 0, 1, 30, -220)
	
	var indicator: Node3D = $Indicator
	var indicator_angle = indicator.rotation_degrees.y
	
	var error = target_angle - indicator_angle
	
	var p_term = p * error
	
	pid["integral"] += error * delta
	var i_term = i * pid["integral"]
	
	var derivative = (error - pid["prev_error"]) / delta
	var d_term = d * derivative
	
	var u = p_term + i_term + d_term
	#u = clamp(u, -1, 1)
	
	pid["prev_error"] = error
	
	if u > 0:
		indicator.rotation_degrees.y += u * dial_speed
	else:
		indicator.rotation_degrees.y += u * dial_speed
