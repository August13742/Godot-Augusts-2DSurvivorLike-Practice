extends Node

class_name AutoPlayComponent


@export var enabled:bool = true
@onready var entity_detection_component:EntityDetectionComponent 
@export var max_speed:int = 150
@export var target_entity:Node2D


func _ready():
	entity_detection_component= owner.find_child("EntityDetectionComponent")
		
func get_direction_to_target(target:Node2D = target_entity):
	if target == null:
		var entity_list = entity_detection_component.get_entities_random()
		if entity_list.size() != 0:
			target = entity_detection_component.get_entities_random()[0]
	if target != null:
		return (target.global_position - owner.global_position).normalized()
	return Vector2.ZERO

func _process(_delta: float) -> void:
	if !enabled: return
	
	var direction:Vector2 = get_direction_to_target()
	owner.velocity = direction * max_speed * 0.25
	owner.move_and_slide()
