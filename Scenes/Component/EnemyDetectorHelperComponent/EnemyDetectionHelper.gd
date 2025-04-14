extends Node
class_name EntityDetectionHelperComponent

#@export var detection_range = 50
var root_entity:Node
var target_entities:Array[Node]


"""
Currently root_entity & Detection Target is hard coded to be of group player and enemies. Modify this Script
for more Modularity 
"""
func _ready():
	root_entity = owner # replace for modularity
	
	

func get_nearby_enemies(detection_range:float)-> Array[Node]:

	if root_entity == null: return []
	target_entities = get_tree().get_nodes_in_group("enemy") # replace for modularity

	if target_entities.size() == 0:return []
	
	var root_entity_position:Vector2 = root_entity.global_position
	target_entities = target_entities.filter(func(enemy:Node2D):
		return enemy.global_position.distance_squared_to(root_entity_position) < pow(detection_range,2)
	)
	
	if target_entities.size() == 0:return []
	
	target_entities.sort_custom(func(a:Node2D,b:Node2D):
		var a_distance = a.global_position.distance_squared_to(root_entity_position)
		var b_distance = b.global_position.distance_squared_to(root_entity_position)
		return a_distance < b_distance
		)
	
	return target_entities
