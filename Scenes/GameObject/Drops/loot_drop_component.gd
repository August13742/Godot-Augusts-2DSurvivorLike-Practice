extends Node

#enum DropType{
	#Experience,
	#Gold,
	#Healing
#}
## to drop multiple types of vials
@export var drops: Array[VialData]
@onready var health_component:HealthComponent = $"../HealthComponent"


func _ready():
	if health_component == null:
		push_error("Health Component Not Found") 
		return

	(health_component as HealthComponent).died.connect(on_died)

func on_died():
	if !(owner is Node2D):return
	var spawn_position:Vector2 = (owner as Node2D).global_position
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null: return
	
	for drop in drops:
		if randf()>drop.drop_rate: continue
		if drop.scene == null: continue
		var drop_instance:Node2D = drop.scene.instantiate()
		entities_layer.get_parent().add_child(drop_instance)
		drop_instance.global_position = spawn_position
