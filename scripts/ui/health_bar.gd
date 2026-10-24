class_name HealthBar extends ProgressBar

@export_subgroup("Configuration")
@export var always_visible: bool = false
@export var destroy_on_death: bool = true

@export_subgroup("Nodes")
@export var body: PhysicsBody2D

var health_component: HealthComponent

func _ready() -> void:
	await get_tree().create_timer(0.0).timeout
	health_component = body.health_component
	update_bar()
	
	health_component.health_changed.connect(update_bar)
	health_component.died.connect(on_died)

func update_bar() -> void:
	max_value = health_component.max_health
	value = health_component.health if health_component.health > 1.0 else 0.0
	update_visibility()

func update_visibility() -> void:
	if always_visible or value < max_value:
		show()
		return
	
	hide()

func on_died() -> void:
	if destroy_on_death:
		queue_free()
