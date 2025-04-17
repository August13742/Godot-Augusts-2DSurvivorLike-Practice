extends CharacterBody2D

var component_manager



func _ready() -> void:
	component_manager = $ComponentManager #if component_manager.has_component...
	#if component_manager.has_component("DashComponent"):
		#print(true)
