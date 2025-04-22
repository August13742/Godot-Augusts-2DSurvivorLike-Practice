extends CharacterBody2D
class_name Player



@export var max_health:int = 10
@export var max_speed:int = 120
@export var acceleration_smoothing:int = 20
var movement_control_component:MovementControlComponent 

@export var front_sprite:Texture2D = preload("res://Scenes/GameObject/Player/front.png")
@export var side_sprite:Texture2D = preload("res://Assets/kron-pixel/side.png") # facing left
@export var back_sprite:Texture2D = preload("res://Assets/kron-pixel/back.png" )

@onready var sprite:Sprite2D = $Visuals/Sprite2D

func _ready():
	if !$HealthComponent:
		var health_component:HealthComponent = load(
			"res://Scenes/Component/HealthComponent/health_component.tscn").instanciate()
		add_child(health_component)
	$HealthComponent.max_health = max_health
	$HealthComponent.current_health = max_health
	if !$MovementControlComponent:
		movement_control_component = load(
			"res://Scenes/Component/MovementControlComponent/movement_control_component.tscn").instantiate()
		add_child(movement_control_component)
	movement_control_component = $MovementControlComponent
	movement_control_component.max_speed = max_speed
	movement_control_component.acceleration_smoothing = acceleration_smoothing
	movement_control_component.direction_changed.connect(on_direction_changed)
	
	
func on_direction_changed(direction:Vector2):
	if direction.y < 0:
		sprite.texture = back_sprite
	elif direction.y > 0:
		sprite.texture = front_sprite
	elif direction.x < 0:
		sprite.texture = side_sprite
		sprite.flip_h = false
	elif direction.x > 0:
		sprite.texture = side_sprite
		sprite.flip_h = true
	
	
		
