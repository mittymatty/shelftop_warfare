class_name ArmyMan extends CharacterBody2D

@export_subgroup("Nodes")
@export var movement_component: MovementComponent
@export var gravity_component: GravityComponent
@export var tracker_component: TrackerComponent
@export var animation_component: AnimationComponent
@export var gun_component: GunComponent
@export var health_component: HealthComponent
@export var drop_chute_raycast: RayCast2D
@export var parachute: Sprite2D

@export var death_sound: AudioStreamPlayer2D
@onready var death_anim: AnimationPlayer = $DeathAnim

var is_parachute_attached: bool = true
var last_target_pos: Vector2 = Vector2.ZERO

func get_nearest_node_in_group(group):
	var nodes = get_tree().get_nodes_in_group(group)
	nodes.sort_custom(func(a,b): return a.global_position.distance_to(global_position)<b.global_position.distance_to(global_position) )
	return nodes.front() if nodes.size() > 0 else null

func _ready() -> void:
	PlayerStatus.active_troops += 1
	SignalBus.emit_troops_changed()
	health_component.damaged.connect(on_damaged)
	health_component.died.connect(on_died)

func handle_parachute () -> void:
	parachute.visible = true
	if drop_chute_raycast.is_colliding():
		is_parachute_attached = false
		parachute.visible = false

func _physics_process(delta: float) -> void:
	var nearest_enemy: Enemy = get_nearest_node_in_group("enemies")
	
	if nearest_enemy and nearest_enemy.global_position.distance_to(global_position) <= tracker_component.start_tracking_distance:
		tracker_component.tracker_target = nearest_enemy
	else:
		tracker_component.tracker_target = null
	
	if !is_parachute_attached:
		gravity_component.handle_gravity(self,delta)
	else:
		velocity.y = 50
		handle_parachute()
	
	#health_component.handle_regen(delta)
	movement_component.handle_horizontal_movement(self,0.0)
	var should_reload: bool = gun_component.ammo == 0 or gun_component.ammo < gun_component.max_ammo and !tracker_component.tracker_target

	if tracker_component.tracker_target:
		var flip_horizontal: float = tracker_component.tracker_target.global_position.x - global_position.x
		animation_component.handle_horizontal_flip(flip_horizontal,false)
		gun_component.handle_gun(delta,tracker_component.tracker_target.global_position,true,should_reload)
		last_target_pos = tracker_component.tracker_target.global_position
	elif should_reload:
			gun_component.handle_gun(delta,last_target_pos,false,true)
	move_and_slide()

func on_damaged(_damage_taken: float) -> void:
	damage_flash()

func damage_flash() -> void:
	var red_flash: Tween = create_tween()
	var white_flash: Tween = create_tween()
	white_flash.tween_property(self,"modulate:v",1,0.1).from(15)
	red_flash.tween_property(self, "modulate:s", 0, 0.1).from(15)

func on_died () -> void:
	PlayerStatus.active_troops -= 1
	SignalBus.emit_troops_changed()
	death_sound.play()
	death_anim.play("die")
	await death_anim.animation_finished
	queue_free()
