extends Node

func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	
	
	
func on_ability_upgrade_added(ability_upgrade:AbilityUpgrade, _current_upgrades:Dictionary):
	if !ability_upgrade is AbilityEquipment:
		return
	var ability = ability_upgrade as AbilityEquipment
	self.add_child(ability.ability_controller_component_scene.instantiate())
	print("Debug/EquipmentUpgrade: [%s] Equipment Added"%ability.name)
