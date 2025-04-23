extends Node
class_name MovementControlComponent

var max_speed:int = 150
var acceleration_smoothing:float = 20
var entity:Node2D
var direction:Vector2
var movement_vector_normalised:Vector2
var movement_command:MovementCommand
var angle_to_target:float

signal direction_changed(Vector2)

func _ready():
	entity = owner
	await get_tree().process_frame
	if movement_command == null:
		push_error("MovementCommand not set")

func _process(delta: float) -> void:
	if movement_command == null: return

	var movement_vector = movement_command.get_movement_vector()
	angle_to_target = movement_command.angle_to_target
	movement_vector_normalised = movement_vector.normalized()

	if direction != movement_vector_normalised:
		direction_changed.emit(movement_vector_normalised)

	direction = movement_vector_normalised
	var target_velocity:Vector2 = direction * max_speed
	entity.velocity = entity.velocity.lerp(target_velocity, 1 - exp(-delta * acceleration_smoothing))
	entity.move_and_slide()
