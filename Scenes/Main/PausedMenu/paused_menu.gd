extends Node


@onready var resume_button := $%ResumeButton
@onready var quit_button := $%QuitButton

func _ready():
	resume_button.pressed.connect(on_resume_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	
func on_resume_pressed():
	if get_tree().paused:
		get_tree().paused = false
		queue_free()

func on_quit_pressed():
	get_tree().quit()
