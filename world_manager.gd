extends Node3D

var has_found_first_mineral = false
var has_entered_main_sub = false
var has_processed_first_mineral = false
var has_processed_nine_minerals = false
var has_arrived_in_coral_reef = false
var has_processed_more_minerals = false
var has_arrived_in_pit = false

func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	
	%DialogManager.queue_next()

func found_first_mineral():
	if has_found_first_mineral: return
	%DialogManager.queue_next()
	has_found_first_mineral = true

func entered_main_sub():
	if has_entered_main_sub or !has_found_first_mineral: return
	%DialogManager.queue_next()
	has_entered_main_sub = true

func processed_first_mineral():
	if has_processed_first_mineral or !has_entered_main_sub: return
	%DialogManager.queue_next()
	has_processed_first_mineral = true

func processed_nine_minerals():
	if has_processed_nine_minerals or !has_processed_first_mineral: return
	%DialogManager.queue_next()
	has_processed_nine_minerals = true

func arrived_in_coral_reef():
	if has_arrived_in_coral_reef or !has_processed_nine_minerals: return
	%DialogManager.queue_next()
	has_arrived_in_coral_reef = true

func processed_more_minerals():
	if has_processed_more_minerals or !has_arrived_in_coral_reef: return
	%DialogManager.queue_next();
	has_processed_more_minerals = true

func arrived_in_pit():
	if has_arrived_in_pit or !has_processed_more_minerals: return
	%DialogManager.queue_next();
	has_arrived_in_pit = true
