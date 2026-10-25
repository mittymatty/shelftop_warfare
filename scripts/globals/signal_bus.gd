extends Node

signal enter_placement_mode
signal enter_shoot_mode
signal setup_wave
signal begin_wave
signal wave_ended
signal enemy_defeated
signal blocks_changed
signal game_over
signal game_won
signal troops_changed

func emit_enter_placement_mode () -> void:
	enter_placement_mode.emit()

func emit_enter_shoot_mode () -> void:
	enter_shoot_mode.emit()

func emit_begin_wave () -> void:
	begin_wave.emit()

func emit_setup_wave () -> void:
	setup_wave.emit()

func emit_wave_ended () -> void:
	wave_ended.emit()

func emit_enemy_defeated () -> void:
	enemy_defeated.emit()

func emit_blocks_changed() -> void:
	blocks_changed.emit()

func emit_game_over() -> void:
	game_over.emit()

func emit_game_won() -> void:
	game_won.emit()

func emit_troops_changed() -> void:
	troops_changed.emit()
