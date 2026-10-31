class_name HealthComponent extends Node

@export_subgroup("Configuration")
@export var max_health: float = 100.0
@export var knockback_multiplier: float = 1.0
@export var invulnerable: bool = false
@export var i_time: bool = false

@export_subgroup("Nodes")
@export var body: PhysicsBody2D
@export var invincibility_timer: Timer

@export_subgroup("Regen Configuration")
@export var regen_delay_timer: Timer
@export var regen_per_second: float = 5.0


@onready var health: float = max_health
var dead: bool = false

signal health_changed
signal damaged (damage: float)
signal died

func get_health() -> float:
	return health

#for health-changing methods aside from damage
func affect_health(affect_by: float) -> void:
	health = clampf(health + affect_by, 0.0, max_health)
	
	if !is_zero_approx(affect_by):
		health_changed.emit()
	
	if health <= 0.0:
		dead = true
		died.emit()

func set_health(new_health: float) -> void:
	health = new_health
	health_changed.emit()

func get_is_affectable() -> bool:
	return invincibility_timer.is_stopped() and !invulnerable and !dead

func handle_regen (delta: float) -> void: #Call in physics process
	if regen_delay_timer and regen_delay_timer.is_stopped():
		affect_health(regen_per_second * delta)

func take_damage(damage: float, knockback: Vector2, _from: Vector2) -> void:
	if !get_is_affectable(): return
	if i_time: invincibility_timer.start()
	
	affect_health(-damage)
	damaged.emit(damage)
	
	if is_instance_valid(regen_delay_timer) and !dead:
		regen_delay_timer.start()
	
	if "velocity" in body:
		body.velocity += knockback * knockback_multiplier
