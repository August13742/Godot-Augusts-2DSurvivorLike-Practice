extends CharacterBody2D

@export var max_speed:int = 75
@onready var health_component = $HealthComponent


func _process(_delta: float) -> void:
	var direction:Vector2 = get_direction_to_player()
	velocity = direction * max_speed
	move_and_slide()

func get_direction_to_player():
	var player_node:Node2D = get_tree().get_first_node_in_group("player")
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
