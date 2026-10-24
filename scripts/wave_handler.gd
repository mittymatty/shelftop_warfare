extends Node2D

@export var waves: Array[PackedScene] # Will stay the same
@onready var remaining_waves: Array[PackedScene] = waves.duplicate() # Will change

var current_wave: Node2D

func _physics_process (_delta: float) -> void:
	if !current_wave: return
	var remaining_spawners: int = 0
	for i in current_wave.get_children():
		if i is EnemySpawner:
			remaining_spawners += 1
	
	if remaining_spawners == 0 and PlayerStatus.active_enemies == 0 and !PlayerStatus.current_game_status == PlayerStatus.GAME_STATUS.OVER:
		end_wave()

func end_wave () -> void:
	if remaining_waves.size() == 0:
		SignalBus.emit_game_won()
		PlayerStatus.current_game_status = PlayerStatus.GAME_STATUS.OVER
		return
	
	current_wave.queue_free()
	SignalBus.emit_wave_ended()
	PlayerStatus.blocks += Settings.base_blocks_per_wave + PlayerStatus.current_wave
	SignalBus.emit_blocks_changed()

func make_wave () -> void:
	var wave_to_make: PackedScene = remaining_waves.pop_front()
	var new_wave: Node2D = wave_to_make.instantiate()
	PlayerStatus.current_wave += 1 # Otherwise the waves would start on 0 #waves.find(wave_to_make) +
	add_child(new_wave)
	SignalBus.emit_begin_wave()
	current_wave = new_wave

func on_setup_wave () -> void:
	if remaining_waves.size() > 0:
		make_wave()

func _ready() -> void:
	SignalBus.setup_wave.connect(on_setup_wave)
