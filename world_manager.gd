extends Node3D

var has_found_first_mineral = false
var has_entered_main_sub = false

func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	
	%DialogManager.queue_next()

func found_first_mineral():
	if has_found_first_mineral: return
	%DialogManager.queue_next()
	has_found_first_mineral = true

func entered_main_sub():
	if has_entered_main_sub or !has_found_first_mineral: return
	%DialogManager.queue_next()
	has_entered_main_sub = true
