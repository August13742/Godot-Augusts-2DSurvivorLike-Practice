extends CharacterBody2D

const MAX_SPEED = 150
## higher means faster initial acceleration
@export var acceleration_smoothing:float = 20
# Called when the node enters the scene tree for the first time.

var num_colliding_bodies:int = 0
var component_manager
@onready var collision_interval_timer = $CollisionDamageInterval

func _ready() -> void:
	component_manager = $ComponentManager #if component_manager.has_component...
	#if component_manager.has_component("DashComponent"):
		#print(true)
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_entered.connect(on_body_exited)
	collision_interval_timer.timeout.connect(on_collision_damage_interval_timer_timeout)
	print($HealthComponent.current_health)
	

func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	#normalise needed because if 1,1 then speed is higher than setting
	var direction = movement_vector.normalized()
	var target_velocity:Vector2 = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1-exp(-delta*acceleration_smoothing))
	move_and_slide()

func get_movement_vector() -> Vector2:
#	moveLeft -> -1 strength, so if both are pressed returns 0 otherwise the correct orientation
	var x_movement = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement,y_movement)
	
	
func check_deal_collision_damage():
	if num_colliding_bodies ==0 || !(collision_interval_timer.is_stopped()): return #aka if timer is running continue
	
	$HealthComponent.damaged(1)
	collision_interval_timer.start()
	
	print($HealthComponent.current_health)
	
	
func on_body_entered(_other:Node2D):
	num_colliding_bodies +=1
	check_deal_collision_damage()
	
	
func on_body_exited(_other:Node2D):
	num_colliding_bodies -=1
	
	
func on_collision_damage_interval_timer_timeout():
	check_deal_collision_damage()
