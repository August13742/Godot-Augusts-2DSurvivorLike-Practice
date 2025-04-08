extends Node
class_name ArenaTimeManager

@export var end_screen_scene:PackedScene
@onready var timer = $Timer

var difficulty_factor:int = 0
var minutes_passed:int = 0


var time_elapsed:float
var time:Array[int] = [0,0]


func _ready():
	timer.timeout.connect(on_timer_timeout)
	
	
func _process(_delta):
	time_elapsed = get_time_elapsed()
	time = TimeUltility.get_minute_seconds(time_elapsed)
	
	raise_difficulty_base_on_minute_passed()

func raise_difficulty_base_on_minute_passed():
	if minutes_passed != time[0]:
		minutes_passed = time[0]
		
		#placeholder, replace with actual algorithm
		#currently, this effects the spawn rate of spawners
		difficulty_factor +=1
		
		GameEvents.emit_difficulty_factor_updated(difficulty_factor)
		
		
func get_time_elapsed()->float:
	return timer.wait_time - timer.time_left
	

func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
