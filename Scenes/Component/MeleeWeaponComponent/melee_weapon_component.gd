extends Node
class_name MeleeWeapon


@export var base_size_scale:float
@export var base_speed_scale:float

@export var speed_rate_upgrade_step:float = 0.1
@export var size_upgrade_step:float = 0.1

@export var damage:float = 1
@export var damage_upgrade_increment:float= 1

@onready var visual_instance = $Visuals
@onready var animation = $AnimationPlayer
@onready var pivot:Node2D = $Pivot

var player:Node2D

func _ready() -> void:
	player = get_parent()
	if player == null:
		push_error("%s Component Cannot Find Player Node, Expects Player to be Direct Parent of this Component"%name)
		
	animation.speed_scale = base_speed_scale
	pivot.scale = Vector2.ONE * base_size_scale
	

	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_one_loop_finished():
	if player==null: return
	
	var angle_to_cursor = (get_viewport().get_mouse_position() - player.global_position).angle()

	#var player_direction:Vector2 = player.global_position
	pivot.rotation = angle_to_cursor


func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id == "auto_weapon_rate":
		var percent_reduction = current_upgrades["auto_weapon_rate"]["quantity"] * speed_rate_upgrade_step
		animation.speed_scale = clamp(base_speed_scale * (1 - percent_reduction), 0.01, 100)
	elif upgrade.id == "auto_weapon_size":
		var percent_increase = current_upgrades["auto_weapon_size"]["quantity"] * size_upgrade_step
		pivot.scale = Vector2.ONE * base_size_scale * (1+percent_increase)
	elif upgrade.id == "auto_weapon_damage":
		damage += current_upgrades["auto_weapon_damage"]["quantity"] * damage_upgrade_increment
	else:
		return
