extends CanvasLayer


@export var arena_time_manger:ArenaTimeManager
@export var resource_managers:Node
var gold_manager:GoldManager

#var current_minute:int = 0

func _ready():
	if arena_time_manger == null: arena_time_manger = get_node("Root/ArenaTimeManager")
	if arena_time_manger == null: push_error("Arena Time Manager Not Found in %s"%name)
		
	if resource_managers == null: resource_managers = get_node("Root/ResourceManagers")
	if resource_managers == null: push_error("Resource Managers Not Found in %s"%name)
	
	gold_manager = resource_managers.get_node("GoldManager")
	if gold_manager == null:push_error("Gold Manager Not Found in %s"%name)
	

func _process(_delta):
	var label_text = ((TimeUtility.format_seconds_to_string(arena_time_manger.time[0],arena_time_manger.time[1]) as String)
		+ "\nGold: %d"%gold_manager.current_gold)
		
	$MarginContainer/Label.text = label_text
