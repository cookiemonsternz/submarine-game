extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_tutorial_button_pressed() -> void:
	%Main.visible = !%Main.visible
	%Tutorial.visible = !%Tutorial.visible
