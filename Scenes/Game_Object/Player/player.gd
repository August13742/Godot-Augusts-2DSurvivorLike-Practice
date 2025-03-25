extends CharacterBody2D

const MAX_SPEED = 150
## higher means faster initial acceleration
@export var acceleration_smoothing:float = 20
# Called when the node enters the scene tree for the first time.

var component_manager

func _ready() -> void:
	component_manager = $ComponentManager #if component_manager.has_component...
	#if component_manager.has_component("DashComponent"):
		#print(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	#normalise needed because if 1,1 then speed is higher than setting
	var direction = movement_vector.normalized()
	var target_velocity:Vector2 = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1-exp(-delta*acceleration_smoothing))
	move_and_slide()

func get_movement_vector() -> Vector2:
#	moveLeft -> -1 strength, so if both are pressed returns 0 otherwise the correct orientation
	var x_movement = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement,y_movement)
	
