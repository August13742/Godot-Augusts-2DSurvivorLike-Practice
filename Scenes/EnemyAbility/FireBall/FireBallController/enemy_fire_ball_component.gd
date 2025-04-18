extends Node
class_name EnemyFireBallController


@export var damage:float = 2
@export var interval:float = 5
@export var speed:int = 100

@onready var fireball_scene:PackedScene = preload("res://Scenes/EnemyAbility/FireBall/fire_ball.tscn")
@onready var timer = $Timer
@onready var target = get_tree().get_first_node_in_group("player")

var can_fire:bool = false #expected to be set by owner

func _ready():
	timer.start(interval)
	timer.timeout.connect(on_timer_timeout)


func get_direction_to_target(_target:Node2D = target):
	if _target != null:
		return (_target.global_position - owner.global_position).normalized()
	return Vector2.ZERO

func on_timer_timeout():
	if can_fire:
		var target_direction:Vector2 = get_direction_to_target()
		var fire_ball_instance:FireBall = fireball_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(fire_ball_instance)
		fire_ball_instance.damage = damage
		fire_ball_instance.speed = speed
		fire_ball_instance.target_direction = target_direction
		fire_ball_instance.global_position = owner.global_position
