extends Node


@export var dasher_event:PackedScene = preload("uid://cfu2ridb03ytq")
@export var enemies_resource = preload("res://Scenes/Managers/EnemyManager/enemy_list.tres")
## offset in addition to viewport_width/2
@export var spawn_radius_offset:int = 30
@export var spawn_interval:float = 5
@export var base_spawn_count:int = 10
@onready var timer = $Timer
@onready var enemies_list:Array[Weighted] = enemies_resource.enemies

var difficulty_factor:float = 1
var player:Node2D
var spawn_count:int = base_spawn_count

var spawn_radius:int = (
	ProjectSettings.get_setting("display/window/size/viewport_width")/2 + spawn_radius_offset
	)
var entities_layer:Node


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	GameEvents.difficulty_factor_updated.connect(on_difficulty_factor_updated)
	timer.wait_time = spawn_interval
	
	player = get_tree().get_first_node_in_group("player")
	if player == null: push_error("Player Not Found [%s]"%self.name)
	entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	
func get_spawn_position()->Vector2:
	'''
	raycasting 4 directions to see if one hits all 4 walls to prevent out of boundary spawning
	'''
	if player == null: return Vector2.ZERO
	
	var spawn_position:Vector2 = Vector2.ZERO
	var random_direction:Vector2 = Vector2.RIGHT.rotated(randf_range(0,TAU))
	
	for i in 4: # 4 directions
		spawn_position = player.global_position + random_direction * spawn_radius
		
		# 1 is terrain layer 1<<0 shift 0 bit is stil l1. useful if layer bit is high, 
		# such as layer index 5 => 2^4 = 16, we can just 1<<4
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position,spawn_position,1) 

		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters) #ray cast
	
		if result.is_empty():
			# all clear
			return spawn_position
		else:
			# collision
			random_direction = random_direction.rotated(deg_to_rad(90))
		
	return spawn_position





func on_timer_timeout():
	if player == null :return
	
	timer.start()
	var spawn_position:Vector2 = Vector2.ONE
	var spawn_batch_size:int = ceili(spawn_count as float / 5)

	for i in range (5):
		spawn_position = get_spawn_position()
		for j in range(spawn_batch_size):
			var enemy_to_spawn:Weighted = WeightedTable.pick_item_from_weighted_table(enemies_list)
			var spawned_enemy_instance:Node2D = enemy_to_spawn.scene.instantiate()
			entities_layer.add_child(spawned_enemy_instance)
			spawned_enemy_instance.global_position = spawn_position + 25*Vector2(randf_range(-1,1),randf_range(-1,1))
			if difficulty_factor > 1:
				set_entity_new_health.call_deferred(spawned_enemy_instance)

func set_entity_new_health(_spawned_enemy_instance):
	_spawned_enemy_instance.max_health *=  1 + difficulty_factor*0.25

	
	
func on_difficulty_factor_updated(number):
	difficulty_factor = number
	change_spawn_interval_based_on_difficulty()
	var dasher_event_instance:Node2D = dasher_event.instantiate()
	entities_layer.add_child(dasher_event_instance)

func change_spawn_interval_based_on_difficulty(step_percentage:float = 0.05):
	var new_timer_interval = spawn_interval-spawn_interval*step_percentage*difficulty_factor
	new_timer_interval = max(0.3,new_timer_interval)
	print("New Spawn Interval %f"%new_timer_interval)
	timer.wait_time = new_timer_interval
	
	spawn_count = base_spawn_count*floor(difficulty_factor)
	print("New Spawn Count %d"%spawn_count)
