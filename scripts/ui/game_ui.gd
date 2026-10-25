extends Control
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var gun_component: GunComponent = player.gun_component

@onready var health_bar: HealthBar = $Vitals/Left/HealthBar
@onready var wave_count: Label = $Vitals/Middle/WaveCount
@onready var blocks_count: Label = $Vitals/Middle/BlocksCount
@onready var ammo_counter: Label = $Vitals/Right/AmmoCounter
@onready var troop_counter: Label = $Vitals/Right/TroopCounter

@onready var troop_select: MarginContainer = $TroopSelect
@onready var troop_button_container: HBoxContainer = $TroopSelect/VBoxContainer/MarginContainer/TroopButtonContainer

@onready var refresh: Button = $TroopSelect/VBoxContainer/HBoxContainer/Refresh
@onready var refresh_price: Label = $TroopSelect/VBoxContainer/HBoxContainer/Refresh/HBoxContainer/Price

@onready var continue_button: Button = $TroopSelect/VBoxContainer/HBoxContainer/ContinueButton
@onready var next_wave_button: Button = $NextWaveButton

@onready var wave_cleared_label: Label = $WaveClearedLabel
@onready var wave_cleared_continue: Button = $WaveClearedLabel/WaveClearedContinue
@onready var win_label: Label = $WinLabel
@onready var game_over_label: Label = $GameOverLabel
@onready var unplaced_troops_notice: Label = $NextWaveButton/UnplacedTroopsNotice

@onready var increase_troops: Button = $TroopSelect/VBoxContainer/HBoxContainer2/IncreaseTroops
@onready var troop_increase_price_label: Label = $TroopSelect/VBoxContainer/HBoxContainer2/IncreaseTroops/HBoxContainer/TroopIncreasePriceLabel

const TROOP_BUTTON = preload("uid://bdmyssrhu4j55")
var trooper_buttons_at_a_time: int = 3

func create_troop_buttons () -> void:
	var possible_troops: Array[TroopData] = PlayerStatus.all_possible_troop_data.duplicate()
	for old: TroopButton in troop_button_container.get_children():
		old.queue_free()
	
	for i: int in trooper_buttons_at_a_time:
		var new_tb: TroopButton = TROOP_BUTTON.instantiate()
		new_tb.troop_data = possible_troops.pop_at(randi_range(0,possible_troops.size() - 1))
		troop_button_container.add_child(new_tb,true)

func on_ammo_changed () -> void:
	ammo_counter.text = "Ammo: " + str(gun_component.ammo) + "/" + str(gun_component.max_ammo)

func on_blocks_changed () -> void:
	blocks_count.text = ": " + str(PlayerStatus.blocks)

func open_troop_selector () -> void:
	PlayerStatus.current_click_mode = PlayerStatus.CLICK_MODE.NONE
	PlayerStatus.current_refresh_cost = PlayerStatus.base_refresh_cost
	update_refresh_label()
	create_troop_buttons()
	increase_troops.show()
	troop_select.show()

func close_troop_selector () -> void:
	var enter_placing_mode: bool = PlayerStatus.stored_troops.size() != 0
	PlayerStatus.current_click_mode = PlayerStatus.CLICK_MODE.PLACE if enter_placing_mode else PlayerStatus.CLICK_MODE.SHOOT
	troop_select.hide()
	next_wave_button.show()
	on_troops_changed()
	#if !enter_placing_mode:
		#SignalBus.emit_setup_wave()

func on_wave_change () -> void:
	next_wave_button.hide()
	wave_count.show()
	wave_count.text = "Wave: " + str(PlayerStatus.current_wave)

func on_refreshed () -> void:
	if PlayerStatus.blocks >= PlayerStatus.current_refresh_cost:
		PlayerStatus.blocks -= PlayerStatus.current_refresh_cost
		PlayerStatus.current_refresh_cost += 1
		SignalBus.emit_blocks_changed()
		update_refresh_label()
		create_troop_buttons()

func update_refresh_label () -> void:
	refresh_price.text = str(PlayerStatus.current_refresh_cost)

func on_wave_cleared () -> void:
	wave_cleared_label.show()
	PlayerStatus.current_click_mode = PlayerStatus.CLICK_MODE.NONE
	await wave_cleared_continue.pressed
	wave_cleared_label.hide()
	open_troop_selector()

func on_game_won () -> void:
	wave_cleared_label.hide()
	win_label.show()
	PlayerStatus.current_click_mode = PlayerStatus.CLICK_MODE.NONE

func on_troops_changed () -> void:
	troop_counter.text = "Troops: " + str(PlayerStatus.active_troops) + "/" + str(PlayerStatus.max_troops_active)
	unplaced_troops_notice.visible = PlayerStatus.stored_troops.size() != 0

func on_next_wave_button_pressed() -> void:
	PlayerStatus.current_click_mode = PlayerStatus.CLICK_MODE.SHOOT
	SignalBus.emit_setup_wave()

func on_increase_troops_pressed() -> void:
	if PlayerStatus.blocks >= PlayerStatus.current_increase_max_troops_cost:
		PlayerStatus.blocks -= PlayerStatus.current_increase_max_troops_cost
		PlayerStatus.current_increase_max_troops_cost += PlayerStatus.increase_max_troops_cost_cost_increase
		PlayerStatus.max_troops_active += 4
		SignalBus.emit_blocks_changed()
		on_troops_changed()
		increase_troops.hide()
		troop_increase_price_label.text = str(PlayerStatus.current_increase_max_troops_cost)

func _ready() -> void:
	health_bar.body = player
	on_ammo_changed()
	on_blocks_changed()
	on_troops_changed()
	
	if PlayerStatus.blocks > 0:
		open_troop_selector()
	else:
		SignalBus.emit_setup_wave()
	
	refresh.pressed.connect(on_refreshed)
	continue_button.pressed.connect(close_troop_selector)
	gun_component.ammo_changed.connect(on_ammo_changed)
	next_wave_button.pressed.connect(on_next_wave_button_pressed)
	increase_troops.pressed.connect(on_increase_troops_pressed)
	
	SignalBus.blocks_changed.connect(on_blocks_changed)
	SignalBus.game_won.connect(on_game_won)
	SignalBus.begin_wave.connect(on_wave_change)
	SignalBus.wave_ended.connect(on_wave_cleared)
	SignalBus.troops_changed.connect(on_troops_changed)
