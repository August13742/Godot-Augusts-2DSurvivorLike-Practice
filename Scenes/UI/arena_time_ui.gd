extends CanvasLayer


@export var arena_time_manger:Node

var current_minute:int = 0

func _process(_delta):
	if arena_time_manger == null: return
	$MarginContainer/Label.text = TimeUltility.format_seconds_to_string(arena_time_manger.time[0],arena_time_manger.time[1])
