extends Node
class_name DeathAnimationComponent

## Leave Empty if using Self
@export var animation_scene:PackedScene
## Leave Empty if using Self
@export var sprite_texture:Texture2D


var health_component:HealthComponent
var foreground:Node2D

func _ready():
	
	if animation_scene == null:
		animation_scene = preload("res://Scenes/Component/DeathComponent/death_animation_particle.tscn")
	if animation_scene == null:
		push_error("[Debug/Referencing]: {%s} Cannot Find Fallback DeathAnimation Scene"%self.name)
		
	if sprite_texture == null:
		var visuals = owner.get_node_or_null("Visuals")
		if visuals:
			var sprite = visuals.get_node_or_null("Sprite2D")
			if sprite and sprite.texture:
				sprite_texture = sprite.texture
			else:
				var animated_sprite = visuals.get_node_or_null("AnimatedSprite2D")
				if animated_sprite:
					sprite_texture = animated_sprite.get_sprite_frames().get_frame_texture("default",0)
					

		if sprite_texture == null:
			push_error("[Debug/Referencing]: {%s} Cannot Find Fallback Sprite or AnimatedSprite Texture" % self.name)

		
	


	foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null: push_error("Foreground Cannot be Found by [%s]"%self.name)
	
	health_component = owner.get_node("HealthComponent")
	health_component.died.connect(on_owner_died)
	
	
func on_owner_died():
	var animation_instance:DeathAnimationParticleScene = animation_scene.instantiate()
	animation_instance.sprite_texture = sprite_texture
	foreground.add_child(animation_instance)
	animation_instance.global_position = owner.global_position
