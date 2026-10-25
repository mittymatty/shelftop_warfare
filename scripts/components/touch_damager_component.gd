class_name TouchDamagerComponent extends Node

@export_subgroup("Configuration")
@export var damage: float = 5.0
@export var knockback: Vector2 = Vector2(50.0,-50.0)

@export_subgroup("Nodes")
@export var hazard_owner: Node2D
@export var attack_box: Area2D
@export var cooldown_timer: Timer

@export_subgroup("Optional Nodes")
@export var attack_sound: AudioStreamPlayer2D

func _ready() -> void:
	attack_box.body_entered.connect(on_attack_box_contact)
	cooldown_timer.timeout.connect(scan_and_deal_damage)

func scan_and_deal_damage() -> void:
	var attack_hit: bool = false
	
	for body in attack_box.get_overlapping_bodies():
		if "health_component" in body:
			var final_knockback: Vector2 = Vector2(knockback.x if hazard_owner.global_position.x < body.global_position.x else -knockback.x, knockback.y)
			body.health_component.take_damage(damage,final_knockback,hazard_owner.global_position)
			attack_hit = true
	
	if attack_hit:
		cooldown_timer.start()
	if attack_hit and attack_sound:
		attack_sound.play()

func on_attack_box_contact(_body: Node2D) -> void:
	if !cooldown_timer.is_stopped(): return
	scan_and_deal_damage()
	
