extends Node
class_name RangedAiMovementComponent

@export var target_entity:Node2D
@export var distance_to_keep:float = 200
@export var distance_tolerance:float = 50


func _ready():
	if owner.moving == true:
		if target_entity == null:
			print("[Debug/Fallback]: {%s} Target not Set, Defaulting Target to Player"%self.name)
			target_entity = get_tree().get_first_node_in_group("player")
	
	distance_to_keep = (Vector2.ONE * distance_to_keep).length()
	distance_tolerance = (Vector2.ONE * distance_tolerance).length()
		
func get_direction_to_target(target:Node2D = target_entity):
	if target == null: return Vector2.ZERO
	
	var distance_error:Vector2 = target.global_position - owner.global_position
	var distance_error_length = distance_error.length()

	if (distance_error_length > distance_tolerance) && (distance_error_length < distance_to_keep):
		return Vector2.ZERO
			
	if distance_error_length > distance_to_keep:
		return (distance_error).normalized()
		
		
	return Vector2.ZERO

func target_at_right_direction(target:Node2D = target_entity)->bool:
	if target == null: return true
	var x_axis_error = abs(target.global_position.x) - abs(owner.global_position.x)
	return true if x_axis_error >= 0 else false
