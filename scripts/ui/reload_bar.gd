class_name ReloadBar extends ProgressBar

@export_subgroup("Nodes")
@export var gun_component: GunComponent

func on_gun_reload () -> void:
	var reload_tween: Tween = create_tween()
	show()
	reload_tween.tween_property(self,"value",max_value,gun_component.reload_timer.wait_time).from(0.0)
	reload_tween.tween_callback(hide)

func _ready() -> void:
	hide()
	gun_component.reload.connect(on_gun_reload)
