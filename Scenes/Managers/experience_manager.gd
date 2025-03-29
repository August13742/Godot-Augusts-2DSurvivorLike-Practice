class_name ExperienceManager
extends Node

signal experience_updated(current_experience:float, target_experience:int)
signal level_up(new_level:int)

var current_experience:float =0
var current_level:int = 1
var target_experience:int = 5

## how much MORE exp needed every level up 
@export var experience_growth:int = 5
func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	
	
func increment_experience(number:float):
	# need to make carry over
	current_experience = min(current_experience + number, target_experience)
	
	experience_updated.emit(current_experience, target_experience)
	
	if current_experience == target_experience:
		current_level += 1
		target_experience += experience_growth
		current_experience = 0
		experience_updated.emit(current_experience,target_experience)
		level_up.emit(current_level)
	
	
func on_experience_vial_collected(number:float):
	increment_experience(number)
