class_name PlacementCursor extends Marker2D

@onready var sprite_valid: Sprite2D = $SpriteValid
@onready var sprite_invalid: Sprite2D = $SpriteInvalid
@onready var validator: RayCast2D = $Validator
@onready var invalidator: Area2D = $Invalidator
@onready var roof_check: RayCast2D = $RoofCheck

@onready var show_before_first_placement: Control = $ShowBeforeFirstPlacement
@onready var instructions: Label = $ShowBeforeFirstPlacement/Instructions
@onready var remaining_troops_label: Label = $RemainingTroopsLabel
@onready var max_troops_label: Label = $MaxTroopsLabel

func check_can_place () -> bool:
	if PlayerStatus.active_troops >= PlayerStatus.max_troops_active:
		return false
	if invalidator.get_overlapping_bodies().size() > 0 or !validator.is_colliding() or roof_check.is_colliding():
		return false
	return true

func place_troop () -> void:
	var troop_to_place: PackedScene = PlayerStatus.stored_troops.front()
	var placed_troop: CharacterBody2D = troop_to_place.instantiate()
	placed_troop.global_transform = global_transform
	placed_troop.global_position.y += -150.0
	get_tree().root.add_child.call_deferred(placed_troop,true)
	if !Settings.expend_troops: return
	PlayerStatus.stored_troops.pop_front()
	#check_and_signal_setup()
#
#func check_and_signal_setup () -> void:
	#if PlayerStatus.stored_troops.size() <= 0:
		#SignalBus.emit_setup_wave()
		#return

func handle_placement (wants_to_place: bool) -> void:
	var can_place: bool = check_can_place()
	var has_reached_max_troops: bool = PlayerStatus.active_troops >= PlayerStatus.max_troops_active
	global_position = get_global_mouse_position()
	
	sprite_invalid.visible = !can_place
	sprite_valid.visible = can_place
	instructions.visible = can_place
	max_troops_label.visible = has_reached_max_troops
	
	remaining_troops_label.text = "Remaining: " + str(PlayerStatus.stored_troops.size())
	
	if can_place and wants_to_place:
		place_troop()
		show_before_first_placement.hide()
	
