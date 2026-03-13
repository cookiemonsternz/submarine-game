class_name DraggableOre extends RigidBody3D

const rock_mesh_1 = preload("res://scenes/world/interactable/draggable_ore/type_1.tscn")
const rock_mesh_2 = preload("res://scenes/world/interactable/draggable_ore/type_2.tscn")
const rock_mesh_3 = preload("res://scenes/world/interactable/draggable_ore/type_3.tscn")
var rock_meshes: Array[PackedScene] = [rock_mesh_1, rock_mesh_2, rock_mesh_3]

var mesh: Node3D

var cooked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"type-1".queue_free()
	
	var rock_mesh_scene = rock_meshes[randi_range(0, 2)]
	var rock_mesh = rock_mesh_scene.instantiate()
	add_child(rock_mesh)
	
	mesh = rock_mesh
	
	$MouseTarget.outline_objects.push_back(rock_mesh.get_child(0))

func start_cook_timer() -> void:
	%Timer.start()

func _on_timer_timeout() -> void:
	cooked = true
	print("Cooked")
	var mesh_instance: MeshInstance3D = mesh.get_child(0)
	var mat: StandardMaterial3D = mesh_instance.get_active_material(0)
	mat.albedo_color = mat.albedo_color.darkened(0.5)
