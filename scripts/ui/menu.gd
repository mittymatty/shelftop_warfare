extends Control

@onready var main: Control = $Main
@onready var difficulty_select: Control = $DifficultySelect

@onready var quit_button: Button = $Main/QuitButton
@onready var start_button: Button = $Main/StartButton
@onready var go_back: Button = $DifficultySelect/GoBack

@onready var easy: Button = $DifficultySelect/VBoxContainer/Easy
@onready var medium: Button = $DifficultySelect/VBoxContainer/Medium
@onready var hard: Button = $DifficultySelect/VBoxContainer/Hard
@onready var monke: Button = $DifficultySelect/VBoxContainer/Monke

const BEDROOM: PackedScene = preload("uid://dwoarnchrrpbi")

func on_start_button_pressed () -> void:
	main.hide()
	difficulty_select.show()

func on_quit_button_pressed () -> void:
	get_tree().quit()

func on_go_back_pressed () -> void:
	difficulty_select.hide()
	main.show()

func switch_to_scene (scene_to_switch_to: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene_to_switch_to)

func _ready() -> void:
	quit_button.pressed.connect(on_quit_button_pressed)
	start_button.pressed.connect(on_start_button_pressed)
	go_back.pressed.connect(on_go_back_pressed)
	
	easy.pressed.connect(switch_to_scene.bind(BEDROOM))
