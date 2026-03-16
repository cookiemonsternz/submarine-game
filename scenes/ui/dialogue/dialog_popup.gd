@tool
class_name DialogPopup extends Control

signal finished

@export var voice_line: AudioStream
@export var audio_player: AudioStreamPlayer3D

@export var dialog_name: String = "Default Name":
	get(): return dialog_name
	set(value): 
		dialog_name = value
		%NameLabel.text = value
@export_custom(PROPERTY_HINT_MULTILINE_TEXT, "Dialog text") var dialog_text: String = "Default dialog text":
	get(): return dialog_text
	set(value):
		dialog_text = value
		%TextLabel.text = value

@export var tween_duration: float = 1.0

func _ready():
	if Engine.is_editor_hint(): return
	
	%NameLabel.visible_ratio = 0.0
	%TextLabel.visible_ratio = 0.0
	modulate.a = 0

func play():
	var opacity_tween = create_tween()
	opacity_tween.tween_property(self, "modulate", Color(1, 1, 1, 1.0), 0.25 * tween_duration)
	
	if audio_player:
		audio_player.stream = voice_line
		audio_player.play()
	else:
		%AudioStreamPlayer.stream = voice_line
		%AudioStreamPlayer.play()
	
	var name_tween = create_tween()
	name_tween.set_trans(Tween.TRANS_EXPO)
	name_tween.tween_property(%NameLabel, "visible_ratio", 1.0, 1.0 * tween_duration)
	
	var text_tween = create_tween()
	text_tween.set_trans(Tween.TRANS_LINEAR)
	text_tween.set_ease(Tween.EASE_IN_OUT)
	text_tween.tween_property(%TextLabel, "visible_ratio", 1.0, (len(%TextLabel.text) / 30.0) * tween_duration)
	
	text_tween.finished.connect(end)

func end():
	await get_tree().create_timer(2.5).timeout
	
	if audio_player:
		if audio_player.playing:
			await audio_player.finished
	elif %AudioStreamPlayer.playing:
		await  %AudioStreamPlayer.finished
	
	finished.emit()
	
	queue_free()
