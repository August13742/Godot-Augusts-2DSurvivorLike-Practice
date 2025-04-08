extends Node


signal experience_vial_collected(number:float)
signal ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary)

func emit_experience_vial_collected(number:float):
	experience_vial_collected.emit(number)

func emit_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	ability_upgrade_added.emit(upgrade,current_upgrades)


signal difficulty_factor_updated(number:float)
func emit_difficulty_factor_updated(number:float):
	difficulty_factor_updated.emit(number)
	
