extends Node

@export var upgrade_pool:Array[Ability]


@export var experience_manager:ExperienceManager
@export var upgrade_screen_scene:PackedScene

var owned_abilities = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)
	
func on_level_up(current_level:int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades:Array[Ability] = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_chosen.connect(on_upgrade_chosen)


func pick_upgrades() -> Array[AbilityUpgrade]:
	var available_upgrades = upgrade_pool.duplicate()
	var chosen_upgrades: Array[AbilityUpgrade] = []
	
	while chosen_upgrades.size() < 3 and available_upgrades.size() > 0:
		var chosen_upgrade = available_upgrades.pick_random()
		
		# Skip if unique and already acquired
		if chosen_upgrade.is_unique and current_upgrades.has(chosen_upgrade.id):
			available_upgrades.erase(chosen_upgrade)
			continue
		
		chosen_upgrades.append(chosen_upgrade)
		available_upgrades.erase(chosen_upgrade)
	
	return chosen_upgrades


func apply_upgrade(ability:Ability):
	var  id = ability.id
	if !owned_abilities.has(id):
		owned_abilities[id] = {
			"resource":ability,
			"level":0
			}
	else:
		var current_level = owned_abilities[id]["level"]
		var max_level = ability.levels.size()-1
		if current_level < max_level:
			owned_abilities[id]["level"] += 1
		
	
	GameEvents.emit_ability_upgrade_added(ability,owned_abilities)
	
func on_upgrade_chosen(upgrade:AbilityUpgrade):
	apply_upgrade(upgrade)
	
