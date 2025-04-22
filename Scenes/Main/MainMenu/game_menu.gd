extends MarginContainer


@onready var start_button:= $VBoxContainer/StartButton
@onready var quit_button := $VBoxContainer/QuitButton



func _ready():
	start_button.pressed.connect(on_start_pressed)

	quit_button.pressed.connect(on_quit_pressed)

	
	
func on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
	
func on_quit_pressed():
	get_tree().quit()
