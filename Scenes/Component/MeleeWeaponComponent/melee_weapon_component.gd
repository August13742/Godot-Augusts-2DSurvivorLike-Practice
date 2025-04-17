extends Node2D
class_name MeleeWeapon


@export var base_size_scale:float = 1

@export var base_cooldown:float = 1.5

@export var damage:float = 5

@onready var visual_instance = $Pivot/Visuals
@onready var animation = $Pivot/AnimationPlayer
@onready var pivot:Node2D = $Pivot
@export var pivot_offset_radius:float = 20

var player:Node2D

func get_animation_speed_scale_from_cooldown(desired_cooldown:float): #animation is 1s
	return 1/desired_cooldown

func _ready() -> void:
	$Pivot/Visuals/HitboxComponent.damage = damage
	
	player = get_parent()
	if player == null:
		push_error("[%s] Component Cannot Find Player Node, Expects Player to be Direct Parent of this Component"%self.name)
		
	
	animation.speed_scale = get_animation_speed_scale_from_cooldown(base_cooldown)
	pivot.scale = Vector2.ONE * base_size_scale
	

	GameEvents.upgrade_ability.connect(on_upgrade_ability)
	
func on_one_loop_finished():
	if player==null: return
	var player_position:Vector2 = player.global_position
	
	var angle_to_cursor = (get_global_mouse_position() - player_position).angle()


	#var player_direction:Vector2 = player.global_position
	pivot.rotation = angle_to_cursor
	
	#pivot.position = Vector2(pivot_offset_radius * cos(angle_to_cursor), pivot_offset_radius * sin(angle_to_cursor))
	pivot.position = Vector2(pivot_offset_radius, 0).rotated(angle_to_cursor)


func on_upgrade_ability(ability:Ability,current_ability_level):
	if ability.id == "auto_attack_upgrade":
		damage *= ability.levels[current_ability_level].damage_multiplier
		animation.speed_scale = get_animation_speed_scale_from_cooldown(
			base_cooldown * ability.levels[current_ability_level].cooldown_multiplier)
		pivot.scale = Vector2.ONE * base_size_scale * ability.levels[current_ability_level].size_multiplier
