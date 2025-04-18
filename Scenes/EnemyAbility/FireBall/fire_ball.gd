extends Node2D
class_name FireBall

var damage:float = 2
var speed:int = 100
var target_direction:Vector2 = Vector2.RIGHT

var motion:Vector2
func _ready():
	await get_tree().process_frame
	var hitbox_component:HitboxComponent = $Visuals/HitboxComponent
	var visuals:Node2D = $Visuals
	hitbox_component.damage = damage

	visuals.rotate(target_direction.angle())
	motion = speed * target_direction
	
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
func _process(delta:float):
	position += motion * delta
	
	
