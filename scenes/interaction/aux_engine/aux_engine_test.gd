extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		%AuxEngine.force = 100
	if Input.is_action_just_released("left"):
		%AuxEngine.force = 0
	
	if Input.is_action_just_pressed("right"):
		%AuxEngine2.force = 100
	if Input.is_action_just_released("right"):
		%AuxEngine2.force = 0
	
	if Input.is_action_just_pressed("up"):
		%AuxEngine3.force = 100
	if Input.is_action_just_released("up"):
		%AuxEngine3.force = 0
	
	if Input.is_action_just_pressed("down"):
		%AuxEngine4.force = 100
	if Input.is_action_just_released("down"):
		%AuxEngine4.force = 0
