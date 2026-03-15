extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "color", Color(0.0, 0.0, 0.0, 0.0), 1.0)
