extends Node
class_name StaticTaserAbilityController


@export var base_cooldown:float = 5
@export var taser_ability_scene:PackedScene = preload("res://Scenes/Ability/static_taser/static_taser.tscn")
@export var damage:float = 1
@export var detection_range:float = 300
@export var base_max_target = 3

@onready var timer:Timer = $Timer
var entity_detector_component:EntityDetectionComponent

var root_entity:Node2D
var foreground:Node2D
var ability_instance:StaticTaserAbility
var _max_target:int

func _ready():
	
	await get_tree().process_frame # needed for referencing to work
	root_entity = owner
	if root_entity == null: push_error("[Debug/Referencing]: {%s} root_entity Cannot be Found"%self.name)
	_max_target = base_max_target
	
	
	entity_detector_component = owner.get_node_or_null("EnemyDetectionComponent")
	
	
	'''
	here, as fallback, detection helper is instantiated automatically.
	this component should be instantiated either manually (then below won't trigger)
	
	or by {AbilityManager}, which sets owner of this script to [owner] of {AbilityManager},
	which is the [root_entity]. so, .owner = owner sets this component's owner to root_entity,
	while the controller itself maintains to be child of {AbilityManager}
	'''
	if entity_detector_component == null: 
		print_debug("[Debug/Referencing]: {%s} EntityDetectionHelperComponent Not Found, Instantiating..."%self.name)
		entity_detector_component = load(
			"res://Scenes/Component/EntityDetectionComponent/entity_detection_component.tscn").instantiate()
		owner.add_child(entity_detector_component)
		entity_detector_component.owner = owner
	''''''
		
	foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null: push_error("[Debug/Referencing]: {%s} Foreground Cannot be Found"%self.name)
	
	timer.wait_time = base_cooldown
	timer.timeout.connect(on_timer_timeout)
	
	GameEvents.upgrade_ability.connect(on_upgrade_ability)
	



func on_timer_timeout():
	if root_entity == null: return

	var taser_instance:StaticTaserAbility = taser_ability_scene.instantiate()
	taser_instance.target_nodes = entity_detector_component.get_entities_random(_max_target)
	
	foreground.add_child(taser_instance)
	taser_instance.damage = damage
	
	taser_instance.global_position = root_entity.global_position
	
	
func on_upgrade_ability(ability:Ability,current_ability_level):
	if ability.id == "static_taser":
		damage *= ability.levels[current_ability_level].damage_multiplier
		timer.wait_time = base_cooldown * ability.levels[current_ability_level].cooldown_multiplier
		_max_target = base_max_target + ability.levels[current_ability_level].instance_bonus
		timer.start()
