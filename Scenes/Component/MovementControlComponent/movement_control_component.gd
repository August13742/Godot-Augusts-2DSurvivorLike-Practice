class_name MovementControlComponent

extends Node

@export var max_speed:int = 150

## higher means faster initial acceleration
@export var acceleration_smoothing:float = 20
@onready var entity:Node2D = get_parent()
var movement_vector:Vector2
var direction:Vector2


func _process(delta: float) -> void:
	
	movement_vector = get_movement_vector()
	#normalise needed because if 1,1 then speed is higher than setting
	direction = movement_vector.normalized()
	
	var target_velocity:Vector2 = direction * max_speed
	entity.velocity = entity.velocity.lerp(target_velocity, 1-exp(-delta*acceleration_smoothing))
	entity.move_and_slide()
	
	
func get_movement_vector() -> Vector2:
#	moveLeft -> -1 strength, so if both are pressed returns 0 otherwise the correct orientation
	var x_movement = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement,y_movement)
