extends Node



@export var basic_enemy_scene:PackedScene
## offset in addition to viewport_width/2
@export var spawn_radius_offset:int = 30
@export var spawn_interval:float = 1

@onready var timer = $Timer

var difficulty_factor:float

var spawn_radius:int = (
	ProjectSettings.get_setting("display/window/size/viewport_width")/2 + spawn_radius_offset
	)


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	GameEvents.difficulty_factor_updated.connect(on_difficulty_factor_updated)
	timer.wait_time = spawn_interval

func on_timer_timeout():
	var player:Node2D = get_tree().get_first_node_in_group("player")
	if player == null :return
	
	timer.start()
	var random_direction:Vector2 = Vector2.RIGHT.rotated(randf_range(0,TAU))
	var spawn_position:Vector2 = player.global_position + random_direction * spawn_radius

	var enemy:Node2D = basic_enemy_scene.instantiate()
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position


func on_difficulty_factor_updated(number):
	difficulty_factor = number

func change_spawn_interval_based_on_difficulty(step_percentage:float = 0.05):
	var new_timer_interval = spawn_interval-spawn_interval*step_percentage*difficulty_factor
	new_timer_interval = max(0.3,new_timer_interval)
	print("New Spawn Interval %f"%new_timer_interval)
	timer.wait_time = new_timer_interval
