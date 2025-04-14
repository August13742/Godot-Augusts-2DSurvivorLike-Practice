extends Node
class_name SwordAbilityController


@export var max_range:int = 100
@export var sword_ability: PackedScene
@export var damage:float = 1
@export var base_cooldown:float = 1.5

@onready var enemies_detector:EntityDetectionHelperComponent
@onready var timer:Timer = $Timer

var root_entity:Node2D

func _ready() -> void:
	enemies_detector = owner.get_node("EnemyDetectionHelperComponent")

	if enemies_detector == null:
		push_error("[Debug/AbilityEquipment]: {%s} Cannot Find Enemy Detection Helper Component"%self.name)
		
	root_entity = owner
	
	timer.wait_time = base_cooldown
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	if root_entity==null: return
	
	var enemies:Array[Node] = enemies_detector.get_nearby_enemies(max_range)
	if enemies.is_empty(): return
	
	
	var sword_instance:SwordAbility = sword_ability.instantiate()

	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance) #get_parent returns parent of player
	sword_instance.hitbox_component.damage = damage
	
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU))*4
	var enemy_direction:Vector2 = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
		timer.wait_time = base_cooldown * (1-percent_reduction)
		timer.start()
