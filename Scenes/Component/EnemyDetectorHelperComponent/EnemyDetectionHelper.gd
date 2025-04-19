extends Node
class_name EntityDetectionHelperComponent

#@export var detection_range = 50
var root_entity:Node
var target_entities:Array[Node]

"""
Currently Detection Target is hard coded to look for group {enemies}. Modify this Script
for more Modularity if Needed
"""

func _ready():
	root_entity = owner
	

func get_nearby_enemies(detection_range:float)-> Array[Node]:

	if root_entity == null: return []
	'''
	a potential better version of this is to use area2D collider as detection range with mask setting
	'''
	target_entities = get_tree().get_nodes_in_group("enemy") # replace for modularity

	if target_entities.size() == 0:return [] # nothing in group
	
	
	var root_entity_position:Vector2 = root_entity.global_position
	target_entities = target_entities.filter(func(enemy:Node2D):
		return enemy.global_position.distance_squared_to(root_entity_position) < pow(detection_range,2)
	)
	
	if target_entities.size() == 0:return [] #nothing in group in detection range
	
	
	target_entities.sort_custom(func(a:Node2D,b:Node2D):
		var a_distance = a.global_position.distance_squared_to(root_entity_position)
		var b_distance = b.global_position.distance_squared_to(root_entity_position)
		return a_distance < b_distance
		)
	
	return target_entities
