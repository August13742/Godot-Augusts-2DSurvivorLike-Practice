extends Node


enum available_components {Dash,Shoot}
const COMPONENT_MAP = {
	available_components.Dash: preload("res://Scenes/Component/Components/dash_component.gd"),
	available_components.Shoot: preload("res://Scenes/Component/Components/shoot_component.gd")
}

@export var component_list:Array[available_components]
var components = {}

func _ready():
	for component in component_list:
		var component_name = available_components.keys()[component]  # Convert enum to string
		
		if has_component(component_name):
			print(("Duplicate components detected: %s already exists. Skipping..." % component_name))
			continue  # Skip duplicates
		if COMPONENT_MAP.has(component):
			var component_script = COMPONENT_MAP[component]  # Get script reference
			var new_component = component_script.new()  # Instantiate it properly

			if new_component is Node:  # Ensure it's a valid Node before adding it
				new_component.name = component_name
				add_component(new_component)
				print("Component added: ", new_component.name)
			else:
				print("Error: Component %s is not a Node and cannot be added." % component_name)
	for child in get_children():
		components[child.name] = child  # Cache components for O(1) lookup
	
	#Debug
	print_tree_pretty()
func add_component(component: Node):
	components[component.name] = component  # Store in dictionary for O(1) lookup
	add_child(component)
	
	
func has_component(component_name: String) -> bool:
	return components.has(component_name)

func get_component(component_name: String):
	return components.get(component_name, null)
	
	
