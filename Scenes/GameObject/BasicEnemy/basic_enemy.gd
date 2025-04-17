extends CharacterBody2D
class_name RatEnemy

@export var max_speed:int = 75
@export var max_health:int = 10
@export var moving:bool = true

@onready var health_component:HealthComponent = $HealthComponent
@onready var sprite:Sprite2D = $Visuals/Sprite2D
@onready var ai_movement_component:MeleeAiMovementComponent = get_node("MeleeAiMovementComponent")


func _ready():
	health_component.max_health = max_health



func _process(_delta: float) -> void:
	if !moving: return
	
	var direction:Vector2 = ai_movement_component.get_direction_to_target()
	velocity = direction * max_speed
	sprite.flip_h = true if velocity.x > 0 else false
	move_and_slide()
