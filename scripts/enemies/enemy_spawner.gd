class_name EnemySpawner extends Marker2D

@export var enemies_left_to_spawn: Array[PackedScene]
@export var spawn_interval: float = 5.0
@export var first_spawn_on_ready: bool = false
@export var initial_delay: float = 0.0
@onready var delay_timer: Timer = $Delay

func spawn_enemy() -> void:
	if enemies_left_to_spawn.size() == 0:
			queue_free()
			return
	
	for i in Settings.enemy_multiplier:
		var next_enemy: PackedScene = enemies_left_to_spawn.front()
		var new_enemy: Enemy = next_enemy.instantiate()
		new_enemy.global_position = global_position
		get_tree().root.add_child.call_deferred(new_enemy,true)
		await get_tree().create_timer(0.25).timeout
	
	enemies_left_to_spawn.pop_front()

func _ready() -> void:
	delay_timer.wait_time = spawn_interval
	if initial_delay > 0.0:
		delay_timer.stop()
		await get_tree().create_timer(initial_delay).timeout
		delay_timer.start()
	if first_spawn_on_ready:
		spawn_enemy()

func _on_delay_timeout() -> void:
	spawn_enemy()
