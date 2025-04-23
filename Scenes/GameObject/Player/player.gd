extends CharacterBody2D
class_name Player

enum InputSourceType {player,AI}
@export var input_type:InputSourceType

@export var max_health:int = 10
@export var max_speed:int = 120
@export var acceleration_smoothing:int = 20
var movement_control_component:MovementControlComponent 

@export var front_sprite:Texture2D = preload("res://Scenes/GameObject/Player/front.png")
@export var side_sprite:Texture2D = preload("res://Assets/kron-pixel/side.png") # facing left
@export var back_sprite:Texture2D = preload("res://Assets/kron-pixel/back.png" )

@onready var sprite:Sprite2D = $Visuals/Sprite2D
@onready var entity_detection_component:EntityDetectionComponent = $EntityDetectionComponent
@onready var health_component:HealthComponent = $HealthComponent

func _ready():
	if !health_component:
		health_component = load(
			"res://Scenes/Component/HealthComponent/health_component.tscn").instanciate()
		add_child(health_component)
	health_component.max_health = max_health
	health_component.current_health = max_health
	if !$MovementControlComponent:
		movement_control_component = load(
			"res://Scenes/Component/MovementControlComponent/movement_control_component.tscn").instantiate()
		add_child(movement_control_component)
	movement_control_component = $MovementControlComponent
	movement_control_component.max_speed = max_speed
	movement_control_component.acceleration_smoothing = acceleration_smoothing
	movement_control_component.direction_changed.connect(on_direction_changed)
	
	if GameEvents.auto_mode:
		self.input_type = InputSourceType.AI
		self.health_component.max_health = 99999
		self.health_component.full_heal()
	
	var input_source:MovementCommand
	if input_type ==  InputSourceType.player:
		input_source = PlayerInputCommand.new()
		GameEvents.level_up.connect(on_level_up_when_player_controlled)
		
	if input_type ==  InputSourceType.AI:
		input_source = AIInputCommand.new()
		input_source.configure(self,entity_detection_component)
		GameEvents.level_up.connect(on_level_up_when_auto_play)

	movement_control_component.movement_command = input_source
	
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
	
func on_level_up_when_auto_play():
	#await get_tree().process_frame
	await get_tree().create_timer(1).timeout
	var upgrade_card = get_tree().get_first_node_in_group("upgrade_card")
	if upgrade_card != null:
		upgrade_card.chosen.emit()
	return null
	
func on_level_up_when_player_controlled():
	health_component.full_heal()
