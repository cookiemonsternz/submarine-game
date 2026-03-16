class_name DialogStarter extends Node3D

@export var initial_dialogue: DialogPopup

func play():
	initial_dialogue.play()

func end():
	queue_free()
