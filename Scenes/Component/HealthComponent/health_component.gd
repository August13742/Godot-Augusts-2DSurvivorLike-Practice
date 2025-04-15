extends Node
class_name HealthComponent

var max_health:float = 10

signal died 
signal health_changed

var current_health:float
func _ready():
	current_health = max_health
	

func heal(amount:float):
	if amount < 0:
		print("cannot heal a negative amount, 
		current_health %f, heal amount %f" % [current_health, amount])
		return
	elif current_health <= 0:
		print("Target is dead, returning early")
		return
	else:
		current_health = min(current_health + amount, max_health)
		health_changed.emit()


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
