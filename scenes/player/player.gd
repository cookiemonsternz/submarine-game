@tool
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HighlightViewport/HighlightCamera3D/HighlightEffectDepth.show()
	$Camera3D/HighlightEffect.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$HighlightViewport/HighlightCamera3D/HighlightEffectDepth.hide()
		$Camera3D/HighlightEffect.hide()
