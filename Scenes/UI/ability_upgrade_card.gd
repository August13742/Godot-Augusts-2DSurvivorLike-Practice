extends PanelContainer

@onready var name_label:RichTextLabel = $VBoxContainer/NameLabel
@onready var description_label:RichTextLabel = $VBoxContainer/MarginContainer/DescriptionLabel
@onready var texture_rect:TextureRect = $VBoxContainer/TextureRect

signal chosen 
func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	
	
func set_ability_upgrade(upgrade:Ability, current_level:int):

	if current_level == -1:
		name_label.text = upgrade.name
		description_label.text = upgrade.description
	else:
		name_label.text = upgrade.name + " +" + str(current_level+1)
		description_label.text = "Increase Effectiveness of this Ability"
	texture_rect.texture = upgrade.icon_texture
	
	
func on_gui_input(event:InputEvent):
	if event.is_action_pressed("left_click"):
		chosen.emit()


func on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self,"scale", Vector2(1.1,1.1),0.2).set_ease(Tween.EASE_IN)


func on_mouse_exited():
	self.scale = Vector2.ONE
	

func _process(_delta):
	'''
	without this, if you zoom your cursor across everything too fast, mouse_exited won't be called as it failed to respond
	'''
	var mouse_pos = get_global_mouse_position()
	if not get_global_rect().has_point(mouse_pos) and scale != Vector2.ONE:
		on_mouse_exited()
