extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#ProjectSettings.load_resource_pack("res://textures.pck")
	#ProjectSettings.load_resource_pack("res://models.pck")
	#ProjectSettings.load_resource_pack("res://audio.pck")
	get_tree().change_scene_to_file("res://main_menu.tscn")
	#pass
