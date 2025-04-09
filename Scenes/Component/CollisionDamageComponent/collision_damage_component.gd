class_name CollisionDamageComponent

extends Area2D

## adjusts the timer interval of which collision damage calcuates
@export var collision_damage_interval:float = 0.8

## Damage Per Trigger
@export var collision_damage:int = 1

var entity:Node2D

var num_colliding_bodies:int = 0
var health_component:HealthComponent

@onready var collision_interval_timer:Timer = $Timer
func _ready():
	if collision_damage_interval <=0:
		collision_damage_interval = max(0.3,collision_damage_interval)
		push_warning("Collision Damage Interval cannot be 0 or Negative, Defaulted to 0.3")
		
	# Component default enables layer 1 and mask 1, so if both are still on, chances are, configuration is forgotten
	if (owner as CollisionObject2D).get_collision_layer_value(1) && (owner as CollisionObject2D).get_collision_mask_value(1):
		push_warning("Remember to configure Collision Layer for %s"%get_parent().name)	
		
	entity = get_parent()
	health_component = get_parent().get_node("HealthComponent")
	if health_component == null: print("Collision Damage Component Expects Health Component But it is Not Found")
	body_entered.connect(on_body_entered)
	body_entered.connect(on_body_exited)
	

func check_deal_collision_damage():
	if health_component == null: return 
	if num_colliding_bodies ==0 || !(collision_interval_timer.is_stopped()): return #aka if timer is running continue
	
	
	health_component.damaged(collision_damage)
	collision_interval_timer.start()
	
	

func on_body_entered(_other:Node2D):
	num_colliding_bodies +=1
	check_deal_collision_damage()
	
	
func on_body_exited(_other:Node2D):
	num_colliding_bodies -=1
	
	
func on_collision_damage_interval_timer_timeout():
	check_deal_collision_damage()
