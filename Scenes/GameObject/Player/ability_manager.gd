extends Node

func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_ability_upgrade_added(ability_upgrade:Ability, current_upgrades:Dictionary):
	var upgrade_id = ability_upgrade.id
	var current_level = current_upgrades[upgrade_id]["level"]

	# auto attack is always equipped
	if upgrade_id == "auto_attack_upgrade" && current_level == 0:
		GameEvents.upgrade_ability.emit(ability_upgrade,current_level)
		return

	#spawn controller if new
	if current_level == 0:
		var ability_scene:Node = ability_upgrade.controller_component_scene.instantiate()
		self.add_child(ability_scene)
		ability_scene.owner = owner # owner should be Player, so ability_scene owner = player

		print("[Debug/EquipmentUpgrade]: {%s} Equipment Added"%ability_upgrade.name)
	else:
		GameEvents.upgrade_ability.emit(ability_upgrade,current_level)
