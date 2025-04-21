extends Node2D
class_name EntityDetectionComponent

@onready var area2D := $Area2D
@onready var collision := $Area2D/CollisionShape2D

@export var detection_radius:int = ProjectSettings.get_setting("display/window/size/viewport_height")/2

var entities_detected: Array[Node2D] = []

func _ready():
	collision.shape.radius = detection_radius
	
	area2D.body_entered.connect(on_body_entered)
	area2D.body_exited.connect(on_entity_exited)


func on_body_entered(other: Node2D):
	entities_detected.append(other)
	
	if !other.tree_exited.is_connected(on_entity_exited):
		other.tree_exited.connect(on_entity_exited.bind(other))


func on_entity_exited(entity:Node2D):
	entities_detected.erase(entity)

func get_entities_random(amount: int = 1) -> Array[Node2D]:
	var pool := entities_detected.duplicate() # shallow copy
	pool.shuffle()
	return pool.slice(0, min(amount, pool.size()))
