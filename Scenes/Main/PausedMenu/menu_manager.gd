extends Node

@export var paused_screen_scene:PackedScene = preload("res://Scenes/Main/PausedMenu/paused_menu.tscn")
var paused_screen:Node


func _input(event:InputEvent):
	
	if event.is_action_pressed("ui_cancel"):
		
		if (get_tree().paused):
			paused_screen.queue_free()
			get_tree().paused = false
			return

		else:
			paused_screen = paused_screen_scene.instantiate()
			self.add_child(paused_screen)
			paused_screen.owner = self
			get_tree().paused = true
