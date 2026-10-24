extends Enemy

@export var trojan_enemies: Array[PackedScene]

func on_died () -> void:
	#overwriting previous death logic
	
	for enemy: PackedScene in trojan_enemies:
		var new_enemy: Enemy = enemy.instantiate()
		new_enemy.global_position = global_position
		new_enemy.global_position.x += randf_range(-50,50)
		get_tree().root.add_child.call_deferred(new_enemy,true)
	
	await get_tree().create_timer(0.05).timeout
	PlayerStatus.active_enemies -= 1
	queue_free()
