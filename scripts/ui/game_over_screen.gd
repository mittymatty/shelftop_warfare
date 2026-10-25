extends Control

@onready var button: Button = $Button

func _on_sadhorns_finished() -> void:
	button.show()

func on_button_pressed () -> void:
	get_tree().change_scene_to_packed(load("uid://rsrpe7sqso4h"))

func _ready() -> void:
	button.pressed.connect(on_button_pressed)
