extends Node2D
class_name GravityAbility


@onready var hitbox_component:HitboxComponent = $Visuals/HitboxComponent
@onready var contraction_timer:Timer = $ContractionTimer
@onready var timer:Timer = $Timer
@onready var visuals:Node2D = $Visuals
@onready var floating_text_scene:PackedScene = preload("uid://wu77mlguuc7n")
@onready var foreground:Node2D = get_tree().get_first_node_in_group("foreground_layer")

var life_time:float = 4
var contraction_force:int = 10
var contraction_interval:float = 0.5

var damage:float = 2
var ability_scale = 1

var entities_inside:Array[Node2D]
var start_position:Vector2
func _ready():
	await get_tree().process_frame
	initiate()
	
	
	
	
func initiate():
	entities_inside = hitbox_component.get_overlapping_bodies()
	for body in entities_inside:
		hitbox_component.body_entered.emit(body)
	hitbox_component.damage = self.damage
	hitbox_component.body_entered.connect(on_body_entered)
	hitbox_component.body_exited.connect(on_body_exited)
	
	contraction_timer.wait_time = contraction_interval
	contraction_timer.start()
	contraction_timer.timeout.connect(on_contraction_timer_timeout)
	contraction_timer.timeout.emit()
	
	timer.wait_time = life_time
	timer.start()
	timer.timeout.connect(on_timer_timeout)
	
	visuals.scale = Vector2.ONE * ability_scale
	start_position = self.global_position
	
	
func on_body_entered(other:Node2D):
	entities_inside.append(other)

func on_body_exited(other:Node2D):
	entities_inside.erase(other)


func on_contraction_timer_timeout():
	entities_inside = entities_inside.filter(func(e): return is_instance_valid(e))
	for entity in entities_inside:
		if entity != null:
			entity.global_position = entity.global_position.lerp(start_position, 0.5)
			entity.health_component.damaged(damage)
			
	var floating_text:Node2D = floating_text_scene.instantiate()
	foreground.add_child(floating_text)
	
	floating_text.global_position = global_position
	floating_text.start("%.1f" % hitbox_component.damage)

func on_timer_timeout():
	queue_free()
	
