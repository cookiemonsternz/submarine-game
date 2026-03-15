extends Node3D

@onready var spawn_pos = $RockSpawnPos
@export var mini_sub_storage: MiniSubStorage
@export var draggable_ore_scene: PackedScene

var on_cooldown := false

func _on_button_pressed() -> void:
	if on_cooldown:
		print("Button on cooldown")
		return
		
	on_cooldown = true
	print("Button pressed")
	if mini_sub_storage.current_stored > 0:
		for i in range(mini_sub_storage.current_stored):
			print("spawn rock")
			var draggable_ore = draggable_ore_scene.instantiate()
			get_tree().root.add_child(draggable_ore)
			draggable_ore.global_position = spawn_pos.global_position
			await get_tree().create_timer(0.3).timeout
		
		mini_sub_storage.current_stored = 0
	else:
		print("nothing")
	await get_tree().create_timer(10.0).timeout
	on_cooldown = false
	print("Cooldown finished")
