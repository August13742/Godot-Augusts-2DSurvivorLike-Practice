extends MovementCommand
class_name AIInputCommand



var detector: EntityDetectionComponent
var target_entity:Node2D
var entity:Node2D
@export var preferred_distance: float = 100
@export var distance_tolerance: float = 35
@export var base_update_interval_frames := 5

var update_interval_frames
var frame_counter := 0
var movement_cache := get_random_direction()
var angle_to_target:float = 0

var idle_timer_frames := 0
var idle_refresh_interval := 15


func configure(_entity: Node2D, _detector: EntityDetectionComponent):
	entity = _entity
	detector = _detector


func get_movement_vector() -> Vector2:
	if target_entity == null and detector:
		var candidates = detector.get_entities_random()
		if candidates.size() > 0:
			target_entity = candidates[0]

	# Delay update to every N frames
	update_interval_frames = base_update_interval_frames
	frame_counter += 1
	if frame_counter % update_interval_frames != 0:
		return movement_cache

	frame_counter = 0

	if target_entity:
		var to_target:Vector2 = target_entity.global_position - entity.global_position
		angle_to_target = to_target.angle()
		var distance_error = to_target.length()

		if distance_error > preferred_distance:
			movement_cache = to_target.normalized()
		elif distance_error > distance_tolerance:
			movement_cache = (movement_cache+get_random_direction()*0.4).normalized()

		else:
			movement_cache = -to_target.normalized() + Vector2(randf_range(-0.1,0.1), randf_range(-0.1,0.1))
			#return Vector2.ZERO

	else:
		increment_idle()

	return movement_cache

func get_random_direction()->Vector2:
	return Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()

func increment_idle():
	idle_timer_frames += 1
	if idle_timer_frames >= idle_refresh_interval:
		movement_cache = get_random_direction()
		idle_timer_frames = 0
