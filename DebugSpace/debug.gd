extends Node2D



func _input(event:InputEvent):
	if event.is_action_pressed("left_click"):
		var instance = load("res://Scenes/Event/dasher_event.tscn").instantiate()
		add_child(instance)
		pass
