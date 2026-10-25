extends Enemy

@export_subgroup("Nodes")
@export var gun_component: GunComponent
@export var touch_damager_component: TouchDamagerComponent

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if tracker_component.tracker_target:
		var distance_from_target: float = tracker_component.tracker_target.global_position.distance_to(global_position)
		var should_shoot: bool = distance_from_target <= tracker_component.stop_tracking_distance * 1.1
		var needs_to_reload: bool = gun_component.ammo == 0
		
		touch_damager_component.scan_and_deal_damage()
		gun_component.handle_gun(delta,target.global_position,should_shoot,needs_to_reload)
