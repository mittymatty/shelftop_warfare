extends Node
enum CLICK_MODE {NONE,SHOOT,PLACE}
enum GAME_STATUS {WAVE,PEACE,OVER}
var current_click_mode: CLICK_MODE = CLICK_MODE.PLACE
var current_game_status: GAME_STATUS = GAME_STATUS.PEACE

var blocks: int = 4 # Starting value
var max_troops_active: int = 5
var stored_troops: Array[PackedScene] = []

var current_increase_max_troops_cost: int = 5
var increase_max_troops_cost_cost_increase: int = 2

var base_refresh_cost: int = 2
var current_refresh_cost: int = 2
var has_used_free_refresh: int = false

var current_wave: int = 0
var active_troops: int = 0
var active_enemies: int = 0

var all_possible_troop_data: Array[TroopData] = [
	preload("res://resources/pistol_trooper.tres"),
	preload("res://resources/rifle_trooper.tres"),
	preload("res://resources/shotgun_trooper.tres"),
	preload("res://resources/two_pistol_troopers.tres"),
	preload("res://resources/rocket_trooper.tres"),
]
