extends Node

@export var dialogues: Array[PackedScene]

var i = 0;
var go_next_when_available: bool = false

func queue_next():
	go_next_when_available = true

func _process(delta: float) -> void:
	if go_next_when_available and get_child_count() == 0:
		go_next_when_available = false
		var scene = dialogues[i].instantiate()
		add_child(scene)
		scene.play()
		
		i += 1
