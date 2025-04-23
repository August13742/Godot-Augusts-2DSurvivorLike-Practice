extends MovementCommand
class_name PlayerInputCommand

var angle_to_target:float

func get_movement_vector() -> Vector2:
#	moveLeft -> -1 strength, so if both are pressed returns 0 otherwise the correct orientation
	var x_movement = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	angle_to_target = Vector2(x_movement,y_movement).angle()
	return Vector2(x_movement,y_movement)
