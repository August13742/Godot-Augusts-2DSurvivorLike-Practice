extends CanvasLayer

@export var arena_time_manger:Node


func _process(_delta):
	if arena_time_manger == null: return
	var time_elapsed = arena_time_manger.get_time_elapsed()
	$MarginContainer/Label.text = format_seconds_to_str(time_elapsed)

func format_seconds_to_str(seconds:float):
	var minutes:int = floor(seconds / 60)
	var remaining_seconds:int = floor(seconds - minutes * 60)
	return str(minutes) + ":" + "%02d" %remaining_seconds
