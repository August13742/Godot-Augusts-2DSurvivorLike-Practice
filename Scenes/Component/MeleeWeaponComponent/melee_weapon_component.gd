extends Node2D
class_name MeleeWeapon


@export var base_size_scale:float = 1

@export var base_cooldown:float = 1.5

@export var damage:float = 5
@export var enable_shockwave:bool = false
var shock_wave_swing_counter:int = 0;
@export var swing_per_shockwave:int = 3

@onready var visual_instance = $Pivot/Visuals
@onready var animation = $Pivot/AnimationPlayer
@onready var pivot:Node2D = $Pivot
@onready var hitbox_component:HitboxComponent = $Pivot/Visuals/HitboxComponent
@export var pivot_offset_radius:float = 20


@onready var movement_control_component:MovementControlComponent
@onready var shockwave_module_component:PackedScene = preload("uid://crh4i2tyhpjl6")

@onready var flame_spiral_module:PackedScene = preload("uid://cy7fpmp78hcwu")
@export var enable_flame_spiral:bool = true
@export var swing_per_spiral:int = 5

var flame_spiral_swing_counter:int = 0

@onready var foreground_layer:Node = get_tree().get_first_node_in_group("foreground_layer")
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

	if enable_shockwave:
		shock_wave_swing_counter +=1
		if shock_wave_swing_counter >= swing_per_shockwave:
			var shockwave_instance:ShockwaveModule = shockwave_module_component.instantiate()
			foreground_layer.add_child(shockwave_instance)
			shockwave_instance.damage = damage as int
			shockwave_instance.global_position = owner.global_position
			shockwave_instance.direction = Vector2.RIGHT.rotated(angle_to_target)
			shockwave_instance.visuals.rotate(angle_to_target)
			shock_wave_swing_counter = 0

	if enable_flame_spiral:
		flame_spiral_swing_counter += 1
		if flame_spiral_swing_counter >= swing_per_spiral:
			var flame_spiral_instance:FlameSprialModule = flame_spiral_module.instantiate()
			self.add_child(flame_spiral_instance)
			flame_spiral_instance.damage = damage as int
			flame_spiral_swing_counter = 0

func on_upgrade_ability(ability:Ability,current_ability_level):
	if ability.id == "auto_attack_upgrade":
		if current_ability_level > 0:
			enable_shockwave = true
			enable_flame_spiral = true
		if current_ability_level ==2:
			swing_per_spiral = 3
		if current_ability_level >=4:
			swing_per_spiral = 2
			swing_per_shockwave = 1

		damage *= ability.levels[current_ability_level].damage_multiplier
		hitbox_component.damage = max(damage,hitbox_component.damage) # technically max isn't needed
		animation.speed_scale = get_animation_speed_scale_from_cooldown(
			base_cooldown * ability.levels[current_ability_level].cooldown_multiplier)
		pivot.scale = Vector2.ONE * base_size_scale * ability.levels[current_ability_level].size_multiplier
