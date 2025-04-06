extends Node
class_name HealthComponent

@export var max_health:float = 10

signal died 
signal health_changed

var current_health:float
func _ready():
	current_health = max_health
	
	
func damaged(damage:float):
	current_health = max(current_health - damage, 0)
	health_changed.emit()
	Callable(check_death).call_deferred()

func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()


func get_health_percent():
	if max_health <= 0: return 0
	
	return min(current_health/max_health,1)
