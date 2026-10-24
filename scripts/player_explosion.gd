class_name Explosion extends Area2D

@export var damage_per_second: float = 50.0
@export var knockback: Vector2 = Vector2(10,-10)

func scan (delta: float) -> void:
	for body: Node2D in get_overlapping_bodies():
		print(body)
		if "health_component" in body:
			var HC: HealthComponent = body.health_component
			HC.take_damage(damage_per_second * delta,knockback,global_position)

func _physics_process(delta: float) -> void:
	scan(delta)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
