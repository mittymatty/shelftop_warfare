extends Control

@onready var button: Button = $Button

const MENU = preload("uid://rsrpe7sqso4h")

func _on_sadhorns_finished() -> void:
	button.show()

func on_button_pressed () -> void:
	get_tree().change_scene_to_packed(MENU)

func _ready() -> void:
	button.pressed.connect(on_button_pressed)
