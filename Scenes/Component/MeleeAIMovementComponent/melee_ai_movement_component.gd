extends Node
class_name MeleeAiMovementComponent

@export var target_entity:Node2D

func _ready():
	if owner.moving == true:
		if target_entity == null:
			print("[Debug/Fallback]: {%s} Target not Set, Defaulting Target to Player"%self.name)
			target_entity = get_tree().get_first_node_in_group("player")
		
func get_direction_to_target(target:Node2D = target_entity):
	if target != null:
		return (target.global_position - owner.global_position).normalized()
	return Vector2.ZERO
