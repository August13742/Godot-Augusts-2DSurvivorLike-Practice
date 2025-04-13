extends Node

@export var upgrade_pool:Array[AbilityUpgrade]
@export var experience_manager:ExperienceManager
@export var upgrade_screen_scene:PackedScene

var current_upgrades = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)
	
func on_level_up(current_level:int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades:Array[AbilityUpgrade] = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_chosen.connect(on_upgrade_chosen)


#func pick_upgrades():
	#var filtered_upgrade = upgrade_pool.duplicate()
	#for i in 3:
		#var chosen_upgrade = filtered_upgrade.pick_random()
		#filtered_upgrade.filter(func(upgrade): return upgrade.id != chosen_upgrade.id)
		#filtered_upgrade.filter(filter_unique_upgrade)
		#
		#
#func filter_unique_upgrade(upgrade:AbilityUpgrade):
	#if (upgrade.is_unique == false) || (upgrade.is_unique == true && current_upgrades[upgrade.id] == null):
		#return true
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
	
	print(chosen_upgrades)
	return chosen_upgrades


func apply_upgrade(upgrade:AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource":upgrade,
			"quantity":1
			}
	else:
		current_upgrades[upgrade.id]["quantity"] +=1
		
	print(current_upgrades)
	
	GameEvents.emit_ability_upgrade_added(upgrade,current_upgrades)
	
func on_upgrade_chosen(upgrade:AbilityUpgrade):
	apply_upgrade(upgrade)
	
