extends StaticBody2D

@export var health_component: HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const GAME_OVER_SCREEN = preload("uid://s58sfxjarahd")

func on_destroyed () -> void:
	
	SignalBus.emit_game_over()
	
	animation_player.play("shake")
	animation_player.speed_scale = 1.5
	await animation_player.animation_finished
	animation_player.play("shake")
	await animation_player.animation_finished
	animation_player.speed_scale = 1.0
	animation_player.play("explode")
	await animation_player.animation_finished
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_packed(GAME_OVER_SCREEN)

func on_damaged (_damage) -> void:
	animation_player.play("shake")

#func _physics_process(delta: float) -> void:
	#health_component.handle_regen(delta)

func _ready() -> void:
	health_component.died.connect(on_destroyed)
	health_component.damaged.connect(on_damaged)
