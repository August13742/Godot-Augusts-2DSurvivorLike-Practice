extends CharacterBody2D
class_name Player



@export var max_health:int = 10
@export var max_speed:int = 120
@export var acceleration_smoothing:int = 20

func _ready():
	if !$HealthComponent:
		var health_component:HealthComponent = load(
			"res://Scenes/Component/HealthComponent/health_component.tscn").instanciate()
		add_child(health_component)
		get_tree().process_frame
	$HealthComponent.max_health = max_health
	$HealthComponent.current_health = max_health
	if !$MovementControlComponent:
		var movement_control_component = load(
			"res://Scenes/Component/MovementControlComponent/movement_control_component.tscn").instantiate()
		add_child(movement_control_component)
		get_tree().process_frame
	$MovementControlComponent.max_speed = max_speed
	$MovementControlComponent.acceleration_smoothing = acceleration_smoothing
	
		
