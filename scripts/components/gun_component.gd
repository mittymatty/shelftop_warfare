class_name GunComponent extends Node

@export_subgroup("Scenes")
@export var bullet : PackedScene

@export_subgroup("Nodes")
@export var gun_visuals: Node2D
@export var muzzle: Marker2D
@export var cooldown_timer: Timer
@export var reload_timer: Timer

@export_subgroup("Optional Nodes")
@export var fire_sound: AudioStreamPlayer2D
@export var reload_sound: AudioStreamPlayer2D

@export_subgroup("Configuration")
@export var bullet_damage: float = 10.0
@export var bullet_speed: float = 400.0
@export var max_ammo: int = 10
@export var bullets_per_shot: int = 1
@export var maximum_spread_angle: float = 0.0

var ammo: int

signal fired
signal reload
signal ammo_changed

func _ready() -> void:
	ammo = max_ammo
	ammo_changed.emit()

func handle_gun (delta: float, target_pos: Vector2, wants_to_shoot: bool, wants_to_reload: bool) -> void:
	rotate_to_target(delta, target_pos)
	if !timers_are_stopped(): return
	if wants_to_shoot and ammo > 0:
		ammo -= 1
		ammo_changed.emit()
		cooldown_timer.start()
		shoot()
	elif wants_to_reload and ammo < max_ammo:
		reload_gun()
	elif wants_to_shoot and ammo == 0:
		reload_gun()

func timers_are_stopped () -> bool:
	return cooldown_timer.is_stopped() and reload_timer.is_stopped()

func rotate_to_target (_delta: float, target_pos: Vector2) -> void:
	gun_visuals.look_at(target_pos)

func shoot () -> void:
	if fire_sound:
		fire_sound.play()
	
	for i in range(bullets_per_shot):
		var angle_offset = lerp(-maximum_spread_angle, maximum_spread_angle, float(i)/bullets_per_shot)
		var b: Bullet = bullet.instantiate()
		b.damage = bullet_damage
		b.speed = bullet_speed
		b.global_transform = muzzle.global_transform
		b.rotation += angle_offset
		get_tree().root.add_child(b)
	fired.emit()

func reload_gun () -> void:
	reload.emit()
	reload_timer.start()
	if reload_sound:
		reload_sound.play()
	await reload_timer.timeout
	ammo = max_ammo
	ammo_changed.emit()
