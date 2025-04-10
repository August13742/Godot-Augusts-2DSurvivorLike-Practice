extends Node
class_name WeaponSwing

"""
change logic from spawning new instances per timer to triggering the same instance,
since weapon swing should likely be unique.
"""
@export var range_scale:float
@export var weapon_swing_ability: PackedScene
@export var damage:float = 1
@export var base_cooldown:float = 1.5

var player:Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_error("%s Component Cannot Find Player Node"%name)
	$Timer.wait_time = base_cooldown
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	if player==null: return

	var player_position:Vector2 = player.global_position 
	
	var weapon_swing_ability_instance:WeaponSwingAbility = weapon_swing_ability.instantiate()
	
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(weapon_swing_ability_instance) #get_parent returns parent of player
	weapon_swing_ability_instance.hitbox_component.damage = damage
	weapon_swing_ability_instance.global_position = player_position
	var player_direction:Vector2 = player.global_position
	weapon_swing_ability_instance.rotation = player_direction.angle()


func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id != "weapon_rate": return
	
	var percent_reduction = current_upgrades["weapon_rate"]["quantity"] * 0.1
	$Timer.wait_time = base_cooldown * (1-percent_reduction)
	$Timer.start()
