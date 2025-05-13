extends Node


@export var end_screen_scene:PackedScene = preload("res://Scenes/UI/EndScreen/end_screen.tscn")

func _ready():
	$%Player.get_node("HealthComponent").died.connect(on_player_died) #no push_error here because other would trigger error
	$ExperienceBar.set_experience_manager($ResourceManagers/ExperienceManager)
	$ResourceManagers/HealingDropManager.set_player($%Player)


func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
