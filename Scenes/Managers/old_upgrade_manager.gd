extends Node

@export var upgrade_pool:Array[AbilityUpgrade]
@export var ability_pool:Array[AbilityEquipment]


@export var experience_manager:ExperienceManager
@export var upgrade_screen_scene:PackedScene

var owned_abilities:Dictionary = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)
	
func on_level_up(current_level:int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades:Array[Ability] = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_chosen.connect(on_upgrade_chosen)


func pick_upgrades() -> Array[Ability]:
	var available_upgrades = upgrade_pool.duplicate()
	var chosen_upgrades: Array[Ability] = []
	
	while chosen_upgrades.size() < 3 and available_upgrades.size() > 0:
		var candidate = available_upgrades.pick_random()
		
		# Skip if maxed out
		if owned_abilities.has(candidate.id):
			var level = owned_abilities[candidate.id]["level"]
			if level >= candidate.levels.size()-1:
				available_upgrades.erase(candidate)
				continue
			
		chosen_upgrades.append(candidate)
		available_upgrades.erase(candidate)
	
	return chosen_upgrades


func apply_upgrade(upgrade:Ability):
	var has_upgrade = owned_abilities.has(upgrade.id)
	if !has_upgrade:
		owned_abilities[upgrade.id] = {
			"resource":upgrade,
			"quantity":1
			}
	else:
		owned_abilities[upgrade.id]["quantity"] +=1
		
	
	GameEvents.emit_ability_upgrade_added(upgrade,owned_abilities)
	
func on_upgrade_chosen(upgrade:Ability):
	apply_upgrade(upgrade)
	

''''''
func get_current_level_data(id:String) -> AbilityLevel:
	var entry = owned_abilities.get(id)
	if entry:
		var level = entry["level"]
	return null
