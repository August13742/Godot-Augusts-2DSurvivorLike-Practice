extends Node

'''
Event BroadCasting Relay
'''

signal level_up
func emit_level_up():
	level_up.emit()


var auto_mode:bool = false	
signal auto_mode_enabled
func emit_auto_mode_enabled():
	auto_mode = true
	auto_mode_enabled.emit()
	
	
signal ability_upgrade_added(upgrade:Ability, current_upgrades:Dictionary)
func emit_ability_upgrade_added(upgrade:Ability, current_upgrades:Dictionary):
	'''check if ability is new, if so, instantiate'''
	ability_upgrade_added.emit(upgrade,current_upgrades)


signal upgrade_ability(ability:Ability,current_level:int) 
func emit_upgrade_ability(ability:Ability,current_level:int):
	'''ability is not new, apply upgrade. this should be catched by all ability controller that can be upgraded'''
	upgrade_ability.emit(ability,current_level)


signal experience_vial_collected(number:float)
func emit_experience_vial_collected(number:float):
	experience_vial_collected.emit(number)

signal healing_drop_collected(number:float)
func emit_healing_drop_collected(number:float):
	healing_drop_collected.emit(number)
	
signal gold_drop_collected(number:int)
func emit_gold_drop_collected(number:int):
	gold_drop_collected.emit(number)
	

signal difficulty_factor_updated(number:float)
func emit_difficulty_factor_updated(number:float):
	difficulty_factor_updated.emit(number)
	
	
signal player_frozen
func emit_player_frozen():
	player_frozen.emit()
