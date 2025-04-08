extends CanvasLayer

var experience_manager:ExperienceManager
@onready var progress_bar = $MarginContainer/ProgressBar

func _ready():
	progress_bar.value = 0

func set_experience_manager(manager):
	experience_manager = manager

	if experience_manager == null:
		push_error("Experience Manager was null when set")
	else:
		experience_manager.experience_updated.connect(on_experience_updated)


func on_experience_updated(current_exp:float, target_exp:float):
	var percent:float = current_exp/target_exp
	progress_bar.value = percent
