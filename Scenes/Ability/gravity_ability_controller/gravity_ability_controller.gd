extends Node
class_name GravityAbilityController


@export var max_range:int = 100
@export var gravity_ability_scene: PackedScene = preload("uid://cy7kaftyofwrq")
@export var damage:float = 1
@export var base_cooldown:float = 15
@export var gravity_ability_life_time:float = 4
@export var gravity_ability_contraction_interval:float = 0.5
@export var gravity_ability_base_scale:float = 1
var gravity_ability_scale:float = 1
@onready var entity_detector_component:EntityDetectionComponent
@onready var timer:Timer = $Timer

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
	timer.start()
	GameEvents.upgrade_ability.connect(on_upgrade_ability)
	
	gravity_ability_scale = gravity_ability_base_scale

func on_timer_timeout():
	if root_entity==null: return
	
	var targets:Array[Node2D] = entity_detector_component.get_entities_random()
	if targets.is_empty(): return
	
	
	for target in targets: #minimum is already 1

		var gravity_instance:GravityAbility = gravity_ability_scene.instantiate()
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(gravity_instance) #get_parent returns parent of player
		gravity_instance.hitbox_component.damage = damage
		gravity_instance.life_time = gravity_ability_life_time
		gravity_instance.contraction_interval = gravity_ability_contraction_interval
		gravity_instance.ability_scale = gravity_ability_scale
		
		gravity_instance.global_position = target.global_position



func on_upgrade_ability(ability:Ability,current_ability_level):
	if ability.id == "gravity_ability":
		damage *= ability.levels[current_ability_level].damage_multiplier
		timer.wait_time = base_cooldown * ability.levels[current_ability_level].cooldown_multiplier
		gravity_ability_scale = gravity_ability_base_scale * ability.levels[current_ability_level].size_multiplier
		timer.start()
