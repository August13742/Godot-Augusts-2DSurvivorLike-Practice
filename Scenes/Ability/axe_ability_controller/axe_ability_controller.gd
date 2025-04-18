extends Node
class_name AxeAbilityController


@export var base_cooldown:float = 5
@export var axe_ability_scene:PackedScene
@export var damage:float = 1
@export var base_spawn_count = 1
@export var base_size_multiplier:float = 1

@onready var timer:Timer = $Timer

var root_entity:Node2D
var foreground:Node2D
var spawn_count = base_spawn_count
var size_multiplier:float = base_size_multiplier

func _ready():
	await get_tree().process_frame
	root_entity = owner
	if root_entity == null: push_error("Player Cannot be Found by [%s]"%self.name)
	foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null: push_error("Foreground Cannot be Found by [%s]"%self.name)
	timer.timeout.connect(on_timer_timeout)
	
	
	GameEvents.upgrade_ability.connect(on_upgrade_ability)
	
	
func on_timer_timeout():
	if root_entity == null: return
	
	var root_entity_position:Vector2 = root_entity.global_position
	
	for i in range(spawn_count):
		var axe_instance:Node2D = axe_ability_scene.instantiate()
		foreground.add_child(axe_instance)

		axe_instance.root_entity = owner

		axe_instance.hitbox_component.damage = damage
		axe_instance.min_scale *= size_multiplier
		axe_instance.global_position = root_entity_position
	

func on_upgrade_ability(ability:Ability,current_ability_level):
	if ability.id == "spiral_axe":
		damage *= ability.levels[current_ability_level].damage_multiplier
		timer.wait_time = base_cooldown * ability.levels[current_ability_level].cooldown_multiplier
		spawn_count = base_spawn_count + ability.levels[current_ability_level].instance_bonus
		size_multiplier = base_size_multiplier * ability.levels[current_ability_level].size_multiplier
		timer.start()
