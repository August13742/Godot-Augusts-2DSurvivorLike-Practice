extends Node2D

class_name ShockwaveModule

@export var damage: int = 3
@export var speed:int = 500
@export var life_time:float = 2


var direction:Vector2 = Vector2.ONE
var movement_vector:Vector2
@onready var hitbox_component:HitboxComponent = $Visuals/HitboxComponent
@onready var visuals:Node2D = $Visuals


var spawned_position:Vector2

func _ready():
	initiate.call_deferred()
	
	
func initiate():
	hitbox_component.damage = self.damage
	spawned_position = self.position
	movement_vector = speed * direction
	
	var tween = create_tween()
	tween.tween_property(visuals, "scale",Vector2.ONE * 2,life_time)
	tween.tween_callback(queue_free)

func _process(_delta:float):
	self.position += movement_vector * _delta
