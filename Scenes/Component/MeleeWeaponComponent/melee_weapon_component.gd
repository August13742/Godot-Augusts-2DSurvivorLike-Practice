extends Node2D
class_name MeleeWeapon


@export var base_size_scale:float = 1

@export var base_cooldown:float = 1.5

@export var damage:float = 5

@onready var visual_instance = $Pivot/Visuals
@onready var animation = $Pivot/AnimationPlayer
@onready var pivot:Node2D = $Pivot
@onready var hitbox_component:HitboxComponent = $Pivot/Visuals/HitboxComponent
@export var pivot_offset_radius:float = 20

@onready var movement_control_component:MovementControlComponent
var controlled_by_player:bool = true
var player:Node2D

func get_animation_speed_scale_from_cooldown(desired_cooldown:float): #animation is 1s
	return 1/desired_cooldown

func _ready() -> void:
	await get_tree().process_frame
	hitbox_component.damage = damage
	movement_control_component = owner.get_node_or_null("MovementControlComponent")
	if movement_control_component == null:
		push_error("MovementControlComponent Not Found")
	player = owner
	if player == null:
		push_error("[%s] Component Cannot Find Player Node, Expects Player to be Direct Parent of this Component"%self.name)
	
	if "input_type" in player:
		if player.input_type == 1:
			controlled_by_player = false
	
	animation.speed_scale = get_animation_speed_scale_from_cooldown(base_cooldown)
	pivot.scale = Vector2.ONE * base_size_scale
	on_one_loop_finished()
	
	GameEvents.upgrade_ability.connect(on_upgrade_ability)
	
func on_one_loop_finished():
	if player==null: return
	
	
	var angle_to_target:float
	if controlled_by_player:
		var player_position:Vector2 = player.global_position
		angle_to_target = (get_global_mouse_position() - player_position).angle()
	else:
		angle_to_target = movement_control_component.angle_to_target

	pivot.rotation = angle_to_target
	
	#pivot.position = Vector2(pivot_offset_radius * cos(angle_to_cursor), pivot_offset_radius * sin(angle_to_cursor))
	pivot.position = Vector2(pivot_offset_radius, 0).rotated(angle_to_target)


func on_upgrade_ability(ability:Ability,current_ability_level):
	if ability.id == "auto_attack_upgrade":
		damage *= ability.levels[current_ability_level].damage_multiplier
		hitbox_component.damage = max(damage,hitbox_component.damage) # technically max isn't needed
		animation.speed_scale = get_animation_speed_scale_from_cooldown(
			base_cooldown * ability.levels[current_ability_level].cooldown_multiplier)
		pivot.scale = Vector2.ONE * base_size_scale * ability.levels[current_ability_level].size_multiplier
