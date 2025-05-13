class_name CollisionDamageComponent
extends Area2D

@export var collision_damage_interval:float = 1:
	set(value):
		collision_damage_interval = 0.5 if value<0.5 else value

@export var collision_damage:int = 1

var entity:Node2D
var num_colliding_bodies:int = 0
var health_component:HealthComponent

var dealt_damage = 0
@onready var projectile_damage_timer: Timer = $ProjectileDamageTimer
@onready var collision_damage_timer: Timer = $CollisionDamageTimer
@export var projectile_damage_interval:float = 0.8:
	set(value):
		projectile_damage_interval = 0.5 if value<0.5 else value

func _ready():
	if collision_damage_interval < 0.5:
		collision_damage_interval = 0.5
		push_error("Collision Damage Interval invalid. Defaulted to 0.5")

	if projectile_damage_interval < 0.5:
		projectile_damage_interval = 0.5
		push_error("Enemy Projectile Damage Interval invalid. Defaulted to 0.5")

	health_component = owner.get_node("HealthComponent")
	if health_component == null:
		push_error("HealthComponent not found for CollisionDamageComponent")

	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	area_entered.connect(on_area_entered)

	collision_damage_timer.wait_time = collision_damage_interval
	projectile_damage_timer.wait_time = projectile_damage_interval

	collision_damage_timer.timeout.connect(on_collision_timer_timeout)


func on_area_entered(other:Node2D):
	if health_component == null: return

	other = other.owner
	if other.is_in_group("enemy_projectile"):
		if "damage" in other:
			if !(projectile_damage_timer.is_stopped()):
				other.queue_free()
				return
			health_component.damaged(other.damage)
			projectile_damage_timer.start()
		else:
			push_warning("Projectile lacks 'damage' or 'get_damage()'. No damage dealt.")

		other.queue_free()
	else:
		print_debug("Anomaly Collision with ",other)


func on_body_entered(_other:Node2D):
	if health_component == null: return

	num_colliding_bodies += 1

	if "collision_damage" in _other:
		#print_debug("Special Collision Damage Dealt")
		health_component.damaged(_other.collision_damage)
		collision_damage_timer.start()
		return

	if num_colliding_bodies > 1 || !(collision_damage_timer.is_stopped()):
		return


	health_component.damaged(collision_damage)
	collision_damage_timer.start()



func on_body_exited(_other:Node2D):
	num_colliding_bodies = max(0, num_colliding_bodies - 1)


func on_collision_timer_timeout():
	check_deal_collision_damage()


func check_deal_collision_damage():
	if health_component == null: return
	if num_colliding_bodies == 0 || !collision_damage_timer.is_stopped(): return

	health_component.damaged(collision_damage)
	collision_damage_timer.start()
