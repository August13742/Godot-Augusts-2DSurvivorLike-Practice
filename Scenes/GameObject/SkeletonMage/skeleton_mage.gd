extends CharacterBody2D
class_name SkeletonMage


@export var max_speed:int = 30
@export var max_health:int = 20
@export var moving:bool = true

@export var distance_to_keep:float = 250
@export var distance_tolerance:float = 100

@export var fireball_interval:float = 5

@onready var health_component:HealthComponent = $HealthComponent
@onready var sprite:AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var ai_movement_component:RangedAiMovementComponent = get_node("RangedAiMovementComponent")

@onready var fire_ball_component = $EnemyFireBallController


func _ready():
	health_component.max_health = max_health
	health_component.current_health = max_health
	ai_movement_component.target_entity = get_tree().get_first_node_in_group("player")
	ai_movement_component.distance_to_keep = distance_to_keep
	ai_movement_component.distance_tolerance = distance_tolerance
	fire_ball_component.interval = fireball_interval

func _process(_delta: float) -> void:
	fire_ball_component.can_fire = true if ai_movement_component.is_stationary else false
	
	if !moving: return
	var direction:Vector2 = ai_movement_component.get_direction_to_target()
	velocity = direction * max_speed


	sprite.flip_h = !(ai_movement_component.target_at_right_direction())
	move_and_slide()

func on_stationary():
	fire_ball_component.can_fire = true
