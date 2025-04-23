extends CharacterBody2D
class_name RatEnemy

@export var max_speed:int = 75
@export var base_max_health:int = 15
@export var moving:bool = true

@onready var health_component:HealthComponent = $HealthComponent
@onready var sprite:Sprite2D = $Visuals/Sprite2D
@onready var ai_movement_component:MeleeAiMovementComponent = get_node("MeleeAiMovementComponent")

var update_interval_frames:int = 3
var frame_counter := 0
var movement_cache:Vector2 = Vector2.ZERO

var max_health:int:
	set(amount):
		max_health = amount
		health_component.max_health = amount
		health_component.full_heal()
		
func _ready():
	max_health = base_max_health
	health_component.max_health = max_health
	health_component.current_health = max_health
	
	ai_movement_component.target_entity = get_tree().get_first_node_in_group("player")



func _process(_delta: float) -> void:
	if !moving: return
	increment_movement()
	move_and_slide()


func increment_movement():
	frame_counter += 1
	if frame_counter % update_interval_frames != 0:
		velocity =  movement_cache

	frame_counter = 0
	var direction:Vector2 = ai_movement_component.get_direction_to_target()
	movement_cache = direction * max_speed
	sprite.flip_h = true if velocity.x > 0 else false
	velocity =  movement_cache
	
