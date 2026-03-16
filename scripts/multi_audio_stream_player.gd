extends "res://scripts/ease_in_audio.gd"

@export var streams: Array[AudioStream]

var i = 0;

func _ready() -> void:
	i = randi_range(0, len(streams) - 1)
	stream = streams[i]
	
	play()


func _on_finished() -> void:
	i += 1
	if i > len(streams) - 1:
		i = 0
	
	stream = streams[i]
	
	play()
