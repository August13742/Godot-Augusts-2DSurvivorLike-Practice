extends Node


@onready var resume_button := $%ResumeButton
@onready var restart_button := $%RestartButton
@onready var menu_button := $%MenuButton
@onready var quit_button := $%QuitButton


func _ready():
	resume_button.pressed.connect(on_resume_pressed)
	restart_button.pressed.connect(on_restart_pressed)
	menu_button.pressed.connect(on_menu_pressed)
	quit_button.pressed.connect(on_quit_pressed)

func on_resume_pressed():
	if get_tree().paused:
		get_tree().paused = false
		queue_free()

func on_quit_pressed():
	get_tree().quit()

func on_menu_pressed():
	get_tree().paused = false
	GameEvents.auto_mode = false
	get_tree().change_scene_to_file("res://Scenes/Main/MainMenu/game_menu.tscn")


func on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
