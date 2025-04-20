extends Camera2D
## Higher Means higher Initial Camera Acceleration Growth
@export var damping_factor:float = 20

## Defaults to Player if not Manually Set
@export var target:Node


var target_position = Vector2.ZERO



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_current()
	if target == null: 
		target = get_tree().get_first_node_in_group("player")
		print_debug("[Debug/Referencing]: Target not Manually Set, Defaulting Camera Target to Player")
		if target == null:
			print_debug("[Debug/Referencing]: Cannot Find Player")
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target == null: return
	target_position = target.global_position
	global_position = global_position.lerp(
		target_position, (1.0-exp(-delta*damping_factor)))
		
