class_name Enemy extends CharacterBody2D

@export_subgroup("Animation")
@export var wobble_walk: bool = true

@export_subgroup("Nodes")
@export var movement_component: MovementComponent
@export var gravity_component: GravityComponent
@export var tracker_component: TrackerComponent
@export var health_component: HealthComponent
@export var jump_component: JumpComponent
@export var jump_detector_component: JumpDetectorComponent
@export var animation_component: AnimationComponent
@export var wobble_animator: AnimationPlayer

var target: PhysicsBody2D

func _ready() -> void:
	SignalBus.game_over.connect(on_died)
	PlayerStatus.active_enemies += 1
	health_component.damaged.connect(on_damaged)
	health_component.died.connect(on_died)
	target = get_tree().get_first_node_in_group("target")
	tracker_component.tracker_target = target

func on_damaged(_damage_taken: float) -> void:
	damage_flash()

func damage_flash() -> void:
	var red_flash: Tween = create_tween()
	var white_flash: Tween = create_tween()
	
	white_flash.tween_property(self,"modulate:v",1,0.1).from(15)
	red_flash.tween_property(self, "modulate:s", 0, 0.1).from(15)

func animate () -> void:
	if is_on_floor_only() and abs(velocity.x) > 0:
		wobble_animator.play("wobble")
	elif wobble_animator.is_playing() and wobble_animator.current_animation != "RESET":
		wobble_animator.play("RESET")

func on_died () -> void:
	PlayerStatus.active_enemies -= 1
	queue_free()

func _physics_process(delta: float) -> void:
	var should_jump: bool = tracker_component.target_is_above and tracker_component.distance_from_target < 250
	gravity_component.handle_gravity(self,delta)
	movement_component.handle_horizontal_movement(self,tracker_component.movement_horizontal)
	jump_component.handle_jump(self,jump_detector_component.check_if_should_jump() or should_jump)
	animation_component.handle_horizontal_flip(velocity.x,false)
	if wobble_walk:
		animate()
	move_and_slide()
