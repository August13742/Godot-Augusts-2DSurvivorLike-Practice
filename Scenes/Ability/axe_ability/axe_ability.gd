extends Node2D

@onready var hitbox_component:HitboxComponent = $Visuals/HitboxComponent
@onready var visuals = $Visuals

@export var max_radius:float = 100

## Determines How much Bigger the ability Gradually Get to
@export var max_scale_multiplier:float = 2
@export var base_min_scale:float = 1.5


'''set max_scale and scale_range base on min_scale'''
@onready var min_scale:float = base_min_scale    # on_ready -> replaced by external value if set
var max_scale = min_scale * max_scale_multiplier
var scale_up_range:float = max(max_scale - min_scale,0)
''''''
var root_entity:Node2D
var base_rotation:Vector2 = Vector2.RIGHT
var self_root_position = Vector2.ZERO
func _ready():
	await get_tree().process_frame
	base_rotation = Vector2.RIGHT.rotated(randf_range(0,TAU))



	var tween = create_tween()
	tween.tween_method(tween_method,0.0, 2.0, 3)
	tween.tween_callback(queue_free)


func tween_method(rotations:float):
	"""
	sprials outwards in clockwise rotation while scaling size up
	"""
	if root_entity == null:
		return

	var percent:float = clamp(rotations / 2.0, 0.0, 1.0)
	var current_radius:float = percent  * max_radius
	var current_direction:Vector2 = base_rotation.rotated(rotations*TAU) # clockwise rotation


	self_root_position = root_entity.global_position

	global_position = self_root_position + (current_direction * current_radius)
	visuals.scale = Vector2.ONE * (min_scale + percent * scale_up_range)
