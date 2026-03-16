extends Control


func _on_play_button_pressed() -> void:
	var center = get_viewport().get_visible_rect().size / 2
	Input.warp_mouse(center)
	get_tree().change_scene_to_file("res://main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_tutorial_button_pressed() -> void:
	%Main.visible = !%Main.visible
	%Tutorial.visible = !%Tutorial.visible


func _on_fullscreen_button_pressed() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
