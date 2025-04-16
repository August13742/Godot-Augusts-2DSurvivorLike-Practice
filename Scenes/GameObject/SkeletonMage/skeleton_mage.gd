extends CharacterBody2D
class_name SkeletonMage


@export var max_speed:int = 50
@export var max_health:int = 20
@export var moving:bool = true

@onready var health_component:HealthComponent = $HealthComponent
@onready var sprite:AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var ai_movement_component:AIMovementComponent = get_node("AIMovementComponent")


func _ready():
	health_component.max_health = max_health
	health_component.current_health = max_health	



func _process(_delta: float) -> void:
	if !moving: return
	
	var direction:Vector2 = ai_movement_component.get_direction_to_target()
	velocity = direction * max_speed

	sprite.flip_h = false if velocity.x > 0 else true
	move_and_slide()
