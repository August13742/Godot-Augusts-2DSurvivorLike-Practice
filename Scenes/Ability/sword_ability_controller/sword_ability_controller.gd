extends Node
class_name SwordAbilityController


@export var max_range:int = 100
@export var sword_ability: PackedScene = preload("res://Scenes/Ability/sword_ability/sword_ability.tscn")
@export var damage:float = 1
@export var base_cooldown:float = 1.5

@onready var entity_detector_component:EntityDetectionComponent
@onready var timer:Timer = $Timer
@export var base_spawn_count = 1
var spawn_count = base_spawn_count
var root_entity:Node2D

func _ready() -> void:
	await get_tree().process_frame
	
	entity_detector_component = owner.get_node("EntityDetectionComponent")
	if entity_detector_component == null: 
		print_debug("[Debug/Referencing]: {%s} EntityDetectionHelperComponent Not Found, Instantiating..."%self.name)
		entity_detector_component = load(
			"res://Scenes/Component/EntityDetectionComponent/entity_detection_component.tscn").instantiate()
		owner.add_child(entity_detector_component)
		entity_detector_component.owner = owner
		
	root_entity = owner
	
	timer.wait_time = base_cooldown
	timer.timeout.connect(on_timer_timeout)
	GameEvents.upgrade_ability.connect(on_upgrade_ability)

func on_timer_timeout():
	if root_entity==null: return
	
	var targets:Array[Node2D] = entity_detector_component.get_entities_random(spawn_count)
	if targets.is_empty(): return
	
	
	for target in targets: #minimum is already 1

		var sword_instance:SwordAbility = sword_ability.instantiate()
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(sword_instance) #get_parent returns parent of player
		sword_instance.hitbox_component.damage = damage
		
		
		sword_instance.global_position = target.global_position
		sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU))*4
		var target_direction:Vector2 = target.global_position - sword_instance.global_position
		sword_instance.rotation = target_direction.angle()


func on_upgrade_ability(ability:Ability,current_ability_level):
	if ability.id == "spawn_sword":
		damage *= ability.levels[current_ability_level].damage_multiplier
		timer.wait_time = base_cooldown * ability.levels[current_ability_level].cooldown_multiplier
		spawn_count = base_spawn_count + ability.levels[current_ability_level].instance_bonus
		timer.start()
