extends Bullet

@export var speed_increase_per_sec: float = 150.0
@export var explosion: PackedScene
@export var explosion_damage_per_second: float = 20.0

func _physics_process(delta):
	speed += speed_increase_per_sec * delta
	position += transform.x * speed * delta

func create_explosion () -> void:
	var new_explosion: Explosion = explosion.instantiate()
	new_explosion.global_transform = global_transform 
	new_explosion.damage_per_second = explosion_damage_per_second
	get_tree().root.call_deferred("add_child",new_explosion)

func _on_body_entered(_body: PhysicsBody2D):
	create_explosion()
	queue_free()

func _on_life_timer_timeout() -> void:
	queue_free()
