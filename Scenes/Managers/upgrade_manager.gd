extends Node

@export var upgrade_pool:Array[Ability]


@export var experience_manager:ExperienceManager
@export var upgrade_screen_scene:PackedScene = preload("res://Scenes/UI/upgrade_screen.tscn")

var owned_abilities = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)
	if upgrade_pool.size() == 0:
		assert(false,"[Critical Error]: {%s} Does Not Have Anything Assigned to it! THIS WILL CAUSE INFINITE LOOP"%self.name)
		
	
func on_level_up(_current_level:int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var picked_upgrades = pick_upgrades()
	var chosen_upgrades:Array[Ability] = picked_upgrades[0]
	var chosen_upgrades_levels:Array[int] = picked_upgrades[1]
	
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades,chosen_upgrades_levels)
	upgrade_screen_instance.upgrade_chosen.connect(on_upgrade_chosen)

func pick_upgrades():
	var available_upgrades:Array[Ability]= upgrade_pool.duplicate()
	var chosen_upgrades: Array[Ability] = []
	var chosen_levels: Array[int] = []

	while chosen_upgrades.size() < 3 and available_upgrades.size() > 0:
		var candidate:Ability = available_upgrades.pick_random()
		available_upgrades.erase(candidate)

		# Skip if maxed out
		if owned_abilities.has(candidate.id):
			var level:int = owned_abilities[candidate.id]["level"]
			if level >= candidate.levels.size() - 1:
				continue
			chosen_levels.append(level)
		else:
			chosen_levels.append(-1) # New ability starts at level 0
			
		chosen_upgrades.append(candidate)
	return [chosen_upgrades, chosen_levels]


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
	
func on_upgrade_chosen(upgrade:Ability):
	apply_upgrade(upgrade)
	
