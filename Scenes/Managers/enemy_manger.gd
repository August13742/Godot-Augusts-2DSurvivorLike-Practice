extends Node

@export var basic_enemy_scene:PackedScene
## offset in addition to viewport_width/2
@export var spawn_radius_offset:int = 30
var spawn_radius:int = (
	ProjectSettings.get_setting("display/window/size/viewport_width")/2 + spawn_radius_offset
	)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player:Node2D = get_tree().get_first_node_in_group("player")
	if player == null :return
	var random_direction:Vector2 = Vector2.RIGHT.rotated(randf_range(0,TAU))
	var spawn_position:Vector2 = player.global_position + random_direction * spawn_radius

	var enemy:Node2D = basic_enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = spawn_position
