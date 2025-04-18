extends Area2D
class_name HurtboxComponent

@onready var health_component:HealthComponent = owner.get_node("HealthComponent")

func _ready():
	area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area:Area2D):
	if health_component == null: return
	if !(other_area is HitboxComponent): return
	
	
	var hitbox_component = other_area as HitboxComponent
	health_component.damaged(hitbox_component.damage)
	
	
