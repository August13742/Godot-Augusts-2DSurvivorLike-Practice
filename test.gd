extends Node



func _input(event:InputEvent):
	if event.is_action_pressed("ui_cancel"):
		print("1")
