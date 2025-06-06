extends CanvasLayer


func _ready():
	get_tree().paused = true
	$%RestartButton.pressed.connect(on_restart_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)

func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")

func on_quit_button_pressed():
	get_tree().quit()


func set_defeat():
	$%TitleLabel.text = "Defeat"
	$%DescriptionLabel.text = "You Lost!"
