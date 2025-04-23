extends Node
class_name HitFlashComponent

## R,G,B, Range is 0~1
@export var target_flash_colour:Vector3 = Vector3(1.0,1.0,1.0)

@onready var health_component:HealthComponent = $"../HealthComponent"
@onready var visuals:Node2D = $"../Visuals"


var hit_flash_material:ShaderMaterial = load(
	"res://Scenes/Component/HitFlashComponent/hit_flash_component_material.tres").duplicate() # cannot use preload
var sprite:CanvasItem
var hit_flash_tween:Tween


func _ready():
	sprite = SpriteUtility2D.get_sprite_as_canvas_item(visuals)
	sprite.material = hit_flash_material
	(sprite.material as ShaderMaterial).set_shader_parameter("target_colour",target_flash_colour)
	
	
	if health_component == null:
		health_component = load("res://Scenes/Component/HealthComponent/health_component.tscn").instantiate()
		owner.add_child(health_component)
		health_component.owner = owner
	
	health_component.received_damage.connect(on_received_damage)



func on_received_damage():
	if hit_flash_tween!= null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
		
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent",1)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material,"shader_parameter/lerp_percent", 0.0,0.2)
	
