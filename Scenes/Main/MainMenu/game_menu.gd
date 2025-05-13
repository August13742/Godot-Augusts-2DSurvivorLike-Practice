extends MarginContainer


@onready var start_button:= $MarginContainer2/VBoxContainer/StartButton
@onready var start_auto:= $MarginContainer2/VBoxContainer/StartAutoButton
@onready var quit_button := $MarginContainer2/VBoxContainer/QuitButton



func _ready():
	start_button.pressed.connect(on_start_pressed)
	start_auto.pressed.connect(on_start_auto_pressed)
	quit_button.pressed.connect(on_quit_pressed)



func on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

func on_quit_pressed():
	get_tree().quit()

func on_start_auto_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
	GameEvents.emit_auto_mode_enabled()
