class_name CollisionDamageComponent
extends Area2D

@export var collision_damage_interval:float = 0.8
@export var collision_damage:int = 1

var entity:Node2D
var num_colliding_bodies:int = 0
var health_component:HealthComponent

@onready var collision_interval_timer:Timer = $Timer
var dealt_damage = 0


func _ready():
	if collision_damage_interval <= 0:
		collision_damage_interval = max(0.3, collision_damage_interval)
		push_warning("Collision Damage Interval invalid. Defaulted to 0.3")

	health_component = owner.get_node("HealthComponent")
	if health_component == null:
		push_error("HealthComponent not found for CollisionDamageComponent")
	
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	area_entered.connect(on_area_entered)
	
	collision_interval_timer.timeout.connect(on_timer_timeout)
	
func on_area_entered(other:Node2D):
	if health_component == null: return
	
	if !(collision_interval_timer.is_stopped()):return
	
	if other.is_in_group("enemy_projectile"):
		print_debug(other.is_in_group("enemy_projectile"))
		print_debug("damage" in other)
	if "damage" in other:
		health_component.damaged(other.damage)
		collision_interval_timer.start()
	else:
		push_warning("Projectile lacks 'damage' or 'get_damage()'. No damage dealt.")
	other.owner.queue_free()
		
		
func on_body_entered(_other:Node2D):
	if health_component == null: return
	
	num_colliding_bodies += 1
	if num_colliding_bodies > 1 || !(collision_interval_timer.is_stopped()):
		return
	health_component.damaged(dealt_damage)
	collision_interval_timer.start()
	
		

func on_body_exited(_other:Node2D):
	num_colliding_bodies = max(0, num_colliding_bodies - 1)


func on_timer_timeout():
	check_deal_collision_damage()


func check_deal_collision_damage():
	if health_component == null: return 
	if num_colliding_bodies == 0 || !collision_interval_timer.is_stopped(): return
	
	health_component.damaged(collision_damage)
	collision_interval_timer.start()
