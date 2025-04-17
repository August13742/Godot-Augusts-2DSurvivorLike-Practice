extends Node
class_name RangedAiMovementComponent

@export var target_entity:Node2D
@export var distance_to_keep:float = 200
@export var distance_tolerance:float = 50


var distance_to_keep_vector:Vector2 = Vector2.ONE * distance_to_keep
var distance_tolerance_vector:Vector2 = Vector2.ONE * distance_tolerance


func _ready():
	if owner.moving == true:
		if target_entity == null:
			print("[Debug/Fallback]: {%s} Target not Set, Defaulting Target to Player"%self.name)
			target_entity = get_tree().get_first_node_in_group("player")
		
func get_direction_to_target(target:Node2D = target_entity):
	if target == null: return Vector2.ZERO
	
	var distance_error:Vector2 = target.global_position - owner.global_position
	if distance_error > distance_tolerance_vector || distance_error < distance_to_keep_vector:
		return Vector2.ZERO
			
	if distance_error > distance_to_keep_vector:
		return (distance_error).normalized()
