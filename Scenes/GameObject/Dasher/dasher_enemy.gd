extends CharacterBody2D
class_name DasherEnemy

@export var max_speed:int = 75
@export var base_max_health:int = 15
@export var moving:bool = true

@export_category("Dash Parameters")
@export var dash_start_range:int = 150
@export var dash_length:int = 220


@export var dash_prep_time:float = 1.5 

## Value Lower than this might be too fast for physics to register collision 
@export var true_dash_time:float = 0.5
@export var dash_cooldown:float = 5

@export var collision_damage:int = 3
@onready var health_component:HealthComponent = $HealthComponent
@onready var sprite:AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var ai_movement_component:MeleeAiMovementComponent = $MeleeAiMovementComponent
@onready var dash_component:EnemyDashAttackComponent = $EnemyDashAttackComponent


var update_interval_frames:int = 3
var frame_counter := 0
var movement_cache:Vector2 = Vector2.ZERO
var target_entity:Node2D 

var max_health:int:
	set(amount):
		max_health = amount
		health_component.max_health = amount
		health_component.full_heal()
		
func _ready():
	target_entity = get_tree().get_first_node_in_group("player")
	ai_movement_component.target_entity = target_entity
	update_attributes.call_deferred()

	
	
func update_attributes():
	max_health = base_max_health
	health_component.max_health = max_health
	health_component.current_health = max_health
	

	dash_component.dash_prep_time = dash_prep_time
	dash_component.true_dash_time = true_dash_time
	dash_component.dash_length = dash_length
	dash_component.dash_cooldown = dash_cooldown
	dash_component.dash_complete.connect(on_dash_complete)
	
	
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
	if dash_component.can_dash && DistanceUtility2D.target_is_in_range(self,target_entity,dash_start_range):
		moving = false
		dash_component.dash(direction)
		
	
	movement_cache = direction * max_speed
	sprite.flip_h = false if velocity.x > 0 else true
	velocity =  movement_cache


func on_dash_complete():
	moving = true
