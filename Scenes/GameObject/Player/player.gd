extends CharacterBody2D

#var component_manager
@export var max_health:int = 10

func _ready():
	$HealthComponent.max_health = max_health

#func _ready() -> void:
	#component_manager = $ComponentManager #if component_manager.has_component...
	##if component_manager.has_component("DashComponent"):
		##print(true)
