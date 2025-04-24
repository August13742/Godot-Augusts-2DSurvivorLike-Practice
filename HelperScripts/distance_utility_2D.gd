extends Object
class_name DistanceUtility2D



static func target_is_in_range(root_entity:Node2D,target_entity:Node2D,_range:int):
	if target_entity == null: return
	return true if root_entity.global_position.distance_squared_to(target_entity.global_position) < pow(_range,2) else false
	
