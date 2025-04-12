extends Node
class_name AxeAbilityController


@export var base_cooldown:float = 5
@export var axe_ability_scene:PackedScene
@export var damage:float = 1

@onready var timer:Timer = $Timer

var player:Node2D
var foreground:Node2D


func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null: push_error("Player Cannot be Found by [%s]"%self.name)
	foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null: push_error("Foreground Cannot be Found by [%s]"%self.name)
	timer.timeout.connect(on_timer_timeout)
	
	
	
func on_timer_timeout():
	if player == null: return
	
	var player_position:Vector2 = player.global_position
	var axe_instance:Node2D = axe_ability_scene.instantiate()
	foreground.add_child(axe_instance)
	axe_instance.hitbox_component.damage = damage
	
	axe_instance.global_position = player_position
	
	
