extends Button

var hovered := false

func _ready():
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func on_mouse_entered():
	hovered = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2).set_ease(Tween.EASE_IN)

func on_mouse_exited():
	hovered = false
	scale = Vector2.ONE

func _process(_delta):
	# Fallback: if mouse is not over this button but it's still scaled
	if hovered && !(get_global_rect().has_point(get_global_mouse_position())):
		on_mouse_exited()
