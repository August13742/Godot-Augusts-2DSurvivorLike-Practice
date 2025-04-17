extends Resource

class_name Ability


@export var id:String
@export var name:String
@export var isUnique:bool = true
@export_multiline var description:String
@export var levels:Array[AbilityLevel] = []

func max_level(current_level: int) -> bool:
	return current_level >= levels.size() - 1
