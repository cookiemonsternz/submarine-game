extends Camera3D

var hovered_target: MouseTarget

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = project_ray_origin(mousepos)
	var end = origin + project_ray_normal(mousepos) * 4096
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	
	query.collision_mask = 0b00000000_00000000_00000001_00000000

	var result = space_state.intersect_ray(query)
	
	if !result: 
		if hovered_target is MouseTarget:
			if hovered_target.is_pressed: return
			hovered_target._on_mouse_exited()
			hovered_target = null
		return
	result = result.collider
	
	if hovered_target == result:
		return
	else:
		if result is MouseTarget:
			if hovered_target is MouseTarget:
				if hovered_target.is_pressed: return
				hovered_target._on_mouse_exited()
			result._on_mouse_entered()
			hovered_target = result
