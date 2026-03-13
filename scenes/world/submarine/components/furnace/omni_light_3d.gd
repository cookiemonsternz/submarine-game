extends OmniLight3D

@onready var noise = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var value = remap(noise.get_noise_1d(Engine.get_frames_drawn() / 10.0), -0.5, 0.5, 1, 10)
	light_energy = value
