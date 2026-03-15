extends AudioStreamPlayer


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -15, 5.0);
