extends AnimatableBody3D

@export var boat: RigidBody3D

var transform_offset: Transform3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transform_offset = get_parent().global_transform
	#print(transform_offset.origin)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	global_transform = boat.global_transform * transform_offset
