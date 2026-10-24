extends Enemy

@export_subgroup("Nodes")
@export var touch_damager_component: TouchDamagerComponent

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	touch_damager_component.scan_and_deal_damage()
