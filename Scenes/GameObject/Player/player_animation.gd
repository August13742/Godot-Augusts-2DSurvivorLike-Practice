extends AnimationPlayer

var movement_control_component:MovementControlComponent
var sprite:Sprite2D

func _ready():
	movement_control_component = owner.get_node("MovementControlComponent")
	if movement_control_component == null:push_error("[Debug/Referencing] {%s} Cannot Find Movement Control Component"%self.name)
	
	sprite = owner.get_node("Visuals").get_node("Sprite2D")
	if sprite == null:push_error("[Debug/Referencing] {%s} Cannot Find Sprite"%self.name)

func _process(_delta):
	if movement_control_component.movement_vector_normalised.x != 0 || movement_control_component.movement_vector_normalised.y != 0:
		sprite.flip_h = true	 if movement_control_component.movement_vector_normalised.x > 0 else false
		play("Walk")
	else:
		play("RESET")
		
