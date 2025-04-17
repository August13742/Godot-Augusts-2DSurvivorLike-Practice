extends Node


signal ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary)

signal experience_vial_collected(number:float)
func emit_experience_vial_collected(number:float):
	experience_vial_collected.emit(number)

signal healing_drop_collected(number:float)
func emit_healing_drop_collected(number:float):
	healing_drop_collected.emit(number)
	
signal gold_drop_collected(number:int)
func emit_gold_drop_collected(number:int):
	gold_drop_collected.emit(number)
	

func emit_ability_upgrade_added(upgrade:Ability, current_upgrades:Dictionary):
	ability_upgrade_added.emit(upgrade,current_upgrades)


signal difficulty_factor_updated(number:float)
func emit_difficulty_factor_updated(number:float):
	difficulty_factor_updated.emit(number)
	
