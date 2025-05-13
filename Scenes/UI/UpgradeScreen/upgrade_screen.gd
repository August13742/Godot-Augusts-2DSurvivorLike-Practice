extends CanvasLayer
class_name UpgradeScreen


@export var upgrade_card_scene:PackedScene = preload("res://Scenes/UI/AbilityUpgradeCard/ability_upgrade_card.tscn")
@onready var card_container:HBoxContainer = $MarginContainer/CardContainer

signal upgrade_chosen(upgrade:Ability)

func _ready():
	get_tree().paused = true


func set_ability_upgrades(upgrades:Array[Ability],levels:Array[int]):
	if upgrades.size() == 0:
		get_tree().paused = false
		queue_free()
	for i in range(upgrades.size()):
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrades[i],levels[i])
		card_instance.chosen.connect(on_upgrade_selected.bind(upgrades[i]))


func on_upgrade_selected(upgrade:Ability):
	if upgrade != null:
		upgrade_chosen.emit(upgrade)
	get_tree().paused = false
	queue_free()
