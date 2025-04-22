extends Node2D
class_name StaticTaserAbility

@onready var visuals:Node2D = $Visuals
@onready var line:Line2D = $Visuals/Line2D
@export var line_texture:Texture2D
@export var capacitor_texture: Texture2D
@export var capacitor_size:float = 0.75
var damage:float
var target_nodes:Array[Node2D]
var line_points:Array[Vector2]
@onready var damage_text_scene:PackedScene = preload("res://Scenes/UI/floating_text.tscn")


func _ready():
	if line_texture == null:
		print("[Debug/Fallback]: {%s} Line Texuture Not Assigned. Using Default Fallback Texture..."%self.name)
		#line_texture = preload("res://icon.svg") # change this to actual fallback texture
	
	if capacitor_texture == null:
		print("[Debug/Fallback]: {%s} Capacitor Texuture Not Assigned. Using Default Fallback Texture..."%self.name)
		capacitor_texture = preload("res://icon.svg")
		
	$Timer.timeout.connect(on_timer_timeout)
	
	await get_tree().process_frame 
	spawn_capacitors()
	
	
func get_target_global_position(targets:Array[Node2D])->Array[Vector2]:
	if targets.is_empty(): return [] as Array[Vector2]
	var target_positions:Array[Vector2]
	for target in targets:
		if target != null:
			target_positions.append(target.global_position)
	return target_positions
	
func spawn_capacitors():
	if target_nodes.is_empty(): return
	
	line_points = get_target_global_position(target_nodes)


	var start_position = self.position
	var ctr:int = 0
	var capacitor_instances:Array[Sprite2D]
	for enemy_positions in line_points:
		var capacitor = Sprite2D.new()
		capacitor.texture = capacitor_texture
		visuals.add_child(capacitor)
		capacitor.global_position = start_position
		capacitor_instances.append(capacitor)
		'''tweens'''
		var capacitor_tween:Tween = create_tween()
		# basically, fly to location in x seconds
		var target_pos = line_points[ctr]
		capacitor_tween.tween_method(func(progress):
			capacitor.global_position = start_position.lerp(target_pos, progress), 0.0, 1.0, 0.2)
		capacitor_tween.tween_property(capacitor, "modulate:a", 0.0, 0.15)
		capacitor_tween.tween_callback(Callable(capacitor, "queue_free"))  # or .hide()
		ctr+=1
		''''''
	await get_tree().create_timer(0.15).timeout
	line.points = line_points.map(func(global_pos): return line.to_local(global_pos)) #line2D expects local pos
	
	for target in target_nodes:
		if target != null:
			target.health_component.damaged(damage)
			var damage_text:DamageText = damage_text_scene.instantiate()
			get_tree().get_first_node_in_group("foreground_layer").add_child(damage_text)
			damage_text.global_position = target.global_position
			damage_text.start("%.1f" % damage)
	$Timer.start()
	
func on_timer_timeout():
	queue_free()
	
