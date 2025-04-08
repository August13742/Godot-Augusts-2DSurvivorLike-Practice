class_name GoldManager
extends Node

signal gold_updated(current_experience:float, target_experience:int)



var current_gold:int = 0  # intergrate this later with save system

func _ready():
	GameEvents.gold_drop_collected.connect(on_gold_drop_collected)
	
	
func on_gold_drop_collected(number:int):
	current_gold += number
