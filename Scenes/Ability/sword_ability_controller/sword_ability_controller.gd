extends Node

@export var max_range:int = 100
@export var sword_ability: PackedScene
@export var damage:float = 1
@export var base_cooldown:float = 1.5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = base_cooldown
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	var player:Node2D = get_tree().get_first_node_in_group("player")
	if player==null: return
	
	var enemies = get_tree().get_nodes_in_group("enemy")


	var player_position:Vector2 = player.global_position 
	
	enemies = enemies.filter(func(enemy:Node2D):
		return enemy.global_position.distance_squared_to(player_position) < pow(max_range,2)
	)
	if enemies.size() == 0:return
	enemies.sort_custom(func(a:Node2D,b:Node2D):
		var a_distance = a.global_position.distance_squared_to(player_position)
		var b_distance = b.global_position.distance_squared_to(player_position)
		return a_distance < b_distance
	)
	
	var sword_instance:SwordAbility = sword_ability.instantiate()
	player.get_parent().add_child(sword_instance) #get_parent returns parent of player
	sword_instance.hitbox_component.damage = damage
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU))*4
	var enemy_direction:Vector2 = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id != "sword_rate": return
	
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
	$Timer.wait_time = base_cooldown * (1-percent_reduction)
	$Timer.start()
