extends Node2D

@onready var collision:CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite:Sprite2D = $Sprite2D


var target:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)
	
	
func tween_collect(percent:float, start_position:Vector2):
	global_position = start_position.lerp(target.global_position,percent)
	var direction_from_start = target.global_position - start_position
	var target_rotation = (direction_from_start.angle())+deg_to_rad(90)
	rotation_degrees = lerp_angle(rotation_degrees,target_rotation,1-exp(-2*get_process_delta_time()))
	
func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()
	
func disable_collision():
	collision.disabled = true
	
func on_area_entered(_other_area:Area2D):
	Callable(disable_collision).call_deferred()
	target = _other_area.owner
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite,"scale",Vector2(0.3,0.3), 0.2).set_delay(0.55)
	tween.tween_method(tween_collect.bind(global_position),0.0,1.0,0.75).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	tween.chain()
	tween.tween_callback(collect)
