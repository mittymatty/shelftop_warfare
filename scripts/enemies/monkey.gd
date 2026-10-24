extends Enemy

@export_subgroup("Nodes")
@export var touch_damager_component: TouchDamagerComponent

@export var sprite: Node2D

var colors: Array[Color] = [
	Color("ff0000"),
	Color("0f68ffff"),
	Color("d1bc00ff"),
]

func _ready() -> void:
	super._ready()
	sprite.modulate = colors.pick_random()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	touch_damager_component.scan_and_deal_damage()
