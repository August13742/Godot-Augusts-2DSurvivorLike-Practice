extends PanelContainer

@onready var name_label:Label = $VBoxContainer/NameLabel
@onready var description_label:Label = $VBoxContainer/DescriptionLabel
@onready var texture_rect:TextureRect = $VBoxContainer/TextureRect

signal chosen 
func _ready():
	gui_input.connect(on_gui_input)
	
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
