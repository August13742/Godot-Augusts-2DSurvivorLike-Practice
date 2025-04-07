extends Node
@export_range(0,1) var drop_chance:float = 1.0
@export var vial_scene:PackedScene


## to drop multiple types of vials
@export var vial_scenes:Array[PackedScene] 
@onready var health_component:HealthComponent = $"../HealthComponent"

func _ready():
	if health_component == null:
		push_error("Health Component Not Found") 
		return

	(health_component as HealthComponent).died.connect(on_died)

func on_died():
	if randf() >= drop_chance: return
	if vial_scene ==null: return
	if !(owner is Node2D):return
	
	var spawn_position:Vector2 = (owner as Node2D).global_position
	var vial_instance:Node2D = vial_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	entities_layer.get_parent().add_child(vial_instance)
	vial_instance.global_position = spawn_position
