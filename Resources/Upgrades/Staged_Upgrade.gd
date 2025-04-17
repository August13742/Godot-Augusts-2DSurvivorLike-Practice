extends Resource

class_name StagedUpgrade


@export var id:String
@export var name:String
@export var isUnique:bool = true

@export var levels:Array[Dictionary] = [
	{"damage_multiplier":1.1, "cooldown_reduction":0.9, "instance_bonus":1},
]
