extends MeshInstance3D

var is_in_breakable_object = false
var is_active = false

@onready var drill_hitbox: Area3D = $DrillArea
@onready var drill_timer: Timer = $DrillTimer
@onready var animation_drill = $"../minisubrevamp2/clawsub/AnimationPlayer"

func _ready():
	drill_hitbox.monitoring = false
	drill_timer.wait_time = 1.0
	drill_timer.one_shot = true
	drill_timer.timeout.connect(_on_drill_timer_timeout)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and not is_active:
		animation_drill.play("clawScoop")
		is_active = true
		drill_hitbox.monitoring = true
		drill_timer.start()

func _on_drill_timer_timeout():
	drill_hitbox.monitoring = false
	is_active = false


func _on_drill_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("breakable") and is_active:
		area.get_parent().rock_destroy()
		area.queue_free() 

func _on_drill_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("breakable"):
		is_in_breakable_object = false
