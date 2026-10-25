class_name ShakeCamera2D extends Camera2D

@export_subgroup("Nodes")
@export var target: Node2D
@export var target_on_game_over: Node2D

@export_subgroup("Configuration")
@export var decay: float = 0.5  # How quickly the shaking stops [0, 1].
@export var max_offset: Vector2 = Vector2(10.0,10.0)  # Maximum hor/ver shake in pixels.
@export var max_roll: float = 0.1  # Maximum rotation in radians (use sparingly).
@export var bonus_offset: Vector2 = Vector2.ZERO

var trauma: float = 0.0  # Current shake strength.
var trauma_power: int = 2  # Trauma exponent. Use [2, 3].

var game_is_over: bool = false

func on_game_over () -> void:
	game_is_over = true
	target = target_on_game_over

func _ready():
	SignalBus.game_over.connect(on_game_over)
	
	randomize()
	if target and position_smoothing_enabled: # Prevents the initial speedy camera pan
		position_smoothing_enabled = false
		global_position = target.global_position + bonus_offset
		await get_tree().create_timer(0.1).timeout
		position_smoothing_enabled = true

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if game_is_over:
		trauma = 0.35
	
	if target:
		global_position = target.global_position + bonus_offset
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randi_range(-1, 1)
	offset.x = max_offset.x * amount * randi_range(-1, 1)
	offset.y = max_offset.y * amount * randi_range(-1, 1)
