extends Node2D


@export var radius:int = 150
@export var spawn_count:int = 8
var spacing:float
var positions:Array[Vector2]


@export var instance_to_spawn:PackedScene = preload("uid://bxb1anygh4xmi") # dasher UID
@export var frozen_screen_effect_scene:PackedScene = preload("uid://dxu6y60s21gpw") #frozen screen

func get_evenly_placed_points_circle(n, r):
	for i in range(n):
		positions.append(Vector2((r * cos(TAU * i / n)),(r * sin(TAU * i / n))))

func _ready():
	var player:Node2D = get_tree().get_first_node_in_group("player")
	self.global_position = player.global_position
	get_evenly_placed_points_circle(spawn_count,radius)
	var spawned_instances:Array[DasherEnemy]
	
	player.process_mode=Node.PROCESS_MODE_DISABLED
	var frozen_screen_instance:Node = frozen_screen_effect_scene.instantiate()
	self.add_child(frozen_screen_instance)
	for i in range(spawn_count):
		spawned_instances.append(instance_to_spawn.instantiate()) 
		self.add_child(spawned_instances[i])
		spawned_instances[i].owner = self
		spawned_instances[i].position = positions[i]
		spawned_instances[i].dash_component.dash_complete.connect(on_dash_completed.bind(spawned_instances[i]))
	await get_tree().create_timer(0.75).timeout
	player.process_mode=Node.PROCESS_MODE_INHERIT
	frozen_screen_instance.queue_free()
	
func on_dash_completed(instance):
	await get_tree().create_timer(1).timeout
	instance.queue_free()
