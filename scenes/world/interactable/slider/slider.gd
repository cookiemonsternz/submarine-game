@tool
extends Node3D

@export var drag_strength: float = 500.0: 
	get: return drag_strength
	set(value): 
		drag_strength = value
		try_set_draggable(value)
@export_group("Detents")
@export var detents = 7
@export var snap_out_threshold = 0.5
@export_custom(PROPERTY_HINT_EXPRESSION, "Detent Equation") var detent_equation: String \
	= "pow(1.5, 5 * x) * 2"

var dragging = false
var selected_detent = 0.0
var detent_expression = Expression.new()

func try_set_draggable(value):
	if has_node("%Draggable"):
		%Draggable.drag_strength = value

func _ready() -> void:
	if Engine.is_editor_hint():
		set_editable_instance(self, true)
	
	detent_expression.parse(detent_equation, ["x"])
	%Draggable.drag_strength = drag_strength

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	do_detents()

func do_detents():
	if dragging: return
	
	var current_value = %Measureable.get_value()

	if abs(current_value - selected_detent) > snap_out_threshold:
		selected_detent = get_closest_detent()
	
	var difference = current_value - selected_detent
	var factor = sign(difference) * detent_expression.execute([abs(difference)])
	
	%RigidBody3D.apply_central_force(%JoltSliderJoint3D.global_basis.y * factor)

func _on_mouse_target_pressed() -> void:
	dragging = true

func _on_mouse_target_released() -> void:
	dragging = false
	
	selected_detent = get_closest_detent()

func get_closest_detent() -> float:
	var current_value = %Measureable.get_value()
	var closest_detent = round(current_value * detents - 0.5) / (detents - 1)
	closest_detent = clamp(closest_detent, 0, 1)
	return closest_detent
