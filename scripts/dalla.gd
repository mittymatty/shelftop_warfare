extends StaticBody2D

@export var health_component: HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func on_destroyed () -> void:
	SignalBus.emit_game_over()
	#Animate destruction

func on_damaged (_damage) -> void:
	animation_player.play("shake")

#func _physics_process(delta: float) -> void:
	#health_component.handle_regen(delta)

func _ready() -> void:
	health_component.died.connect(on_destroyed)
	health_component.damaged.connect(on_damaged)
