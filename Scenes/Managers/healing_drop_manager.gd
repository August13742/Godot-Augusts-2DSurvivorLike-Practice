extends Node
class_name HealingDropManager

var health_component:HealthComponent
var player

func set_player(player_in_main):
	if player_in_main == null: return
	player = player_in_main
	
	if player == null:
		push_error("Player Not Found")

	health_component = player.get_node("HealthComponent")
	if health_component == null:
		push_error("Health Component Not Found")
		
	GameEvents.healing_drop_collected.connect(on_healing_drop_connected)
	

	
func on_healing_drop_connected(value:float):
	health_component.heal(value)
