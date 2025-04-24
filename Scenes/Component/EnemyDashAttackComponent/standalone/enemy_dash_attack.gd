extends Node2D


@onready var sprite:= $Visuals/Sprite2D
@onready var phantom:= $Visuals/Phantom
@onready var timer := $Timer
@onready var line2D:Line2D = $Visuals/TrajectoryLine
@onready var visuals:Node2D = $Visuals

@export var dash_prep_time:float = 1.5
@export var true_dash_time:float = 0.3
@export var dash_length:int = 75
@export var dash_cooldown = 2

var dash_length_vector:Vector2
var start_position:Vector2
var dash_end_position:Vector2

var line_points: Array[Vector2] = []


func _ready():
	timer.timeout.connect(on_timer_timeout)
	dash_length_vector = dash_length * owner.direction
	timer.wait_time = dash_cooldown

func phantom_tween_method(progression:float):
	phantom.position = Vector2.ZERO.lerp(dash_length_vector,progression)
	

func sprite_tween_method(progression:float):
	global_position = start_position.lerp(dash_end_position,progression)
	

func on_phantom_tween_finished():
	phantom.visible = false
	
	line2D.points.clear()
	line2D.visible = false
	
	var sprite_tween = create_tween()
	sprite_tween.tween_method(sprite_tween_method, 0.0,1.0,true_dash_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	sprite_tween.tween_callback(on_sprite_tween_finished)
	

func on_sprite_tween_finished():
	phantom.position = Vector2.ZERO
	
	
func on_timer_timeout():
	print("tweening")
	phantom.visible = true

	start_position = global_position
	
	dash_end_position = start_position + dash_length_vector
	line_points = [Vector2.ZERO,dash_length_vector]
	line2D.points = line_points
	line2D.visible = true
	
	var phantom_tween = create_tween()
	phantom_tween.tween_method(phantom_tween_method,0.0,1.0,dash_prep_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	phantom_tween.tween_callback(on_phantom_tween_finished)
	
	
func _input(event:InputEvent):
	if event.is_action_pressed("move_right"):
		print("starting")
		timer.start()
	
