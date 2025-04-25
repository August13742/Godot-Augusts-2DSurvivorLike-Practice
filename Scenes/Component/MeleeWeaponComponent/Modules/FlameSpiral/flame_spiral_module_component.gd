extends Node2D
class_name FlameSprialModule

@export var damage: int = 3


@onready var hitbox_component:HitboxComponent = $Visuals/HitboxComponent
@onready var visuals:Node2D = $Visuals
@onready var animation:AnimatedSprite2D = $%AnimatedSprite2D
@onready var floating_text_scene:PackedScene = preload("uid://wu77mlguuc7n")


func initiate():
	var overlapping_bodies:Array[Node2D] = hitbox_component.get_overlapping_bodies()
	for body in overlapping_bodies:
		hitbox_component.body_entered.emit(body)
	hitbox_component.damage = self.damage
	hitbox_component.body_entered.connect(on_body_entered)

func _ready():
	
	var overlapping_bodies:Array[Node2D] = hitbox_component.get_overlapping_bodies()
	for body in overlapping_bodies:
		hitbox_component.body_entered.emit(body)
	hitbox_component.damage = self.damage
	hitbox_component.body_entered.connect(on_body_entered)
	
	#initiate().call_deferred()
	animation.animation_finished.connect(on_animation_finished)


func on_body_entered(other:Node2D):
	other.health_component.damaged(damage)
	var floating_text:Node2D = floating_text_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position
	floating_text.start("%.1f" % hitbox_component.damage)

func on_animation_finished():
	queue_free()
