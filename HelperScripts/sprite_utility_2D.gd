extends Object
class_name SpriteUtility2D
## Helper Functions for Sprite & AnimatedSprite



## Used for setting Shader Material to Sprite. [br]
## visual_pivot is Node2D that's the parent of Sprite
static func get_sprite_as_canvas_item(visual_pivot: Node2D) -> CanvasItem:
	var sprite:CanvasItem = visual_pivot.find_child("Sprite2D")
	if sprite:
		return sprite

	sprite = visual_pivot.get_node_or_null("AnimatedSprite2D")
	if sprite:
		return sprite

	return null



static func get_texture_from_visual(visual_pivot:Node2D)->Texture2D: ## visual_pivot is Node2D that's the parent of Sprite
	var sprite:Sprite2D = visual_pivot.get_node_or_null("Sprite2D")
	if sprite and sprite.texture:
		return sprite.texture

	var anim_sprite:AnimatedSprite2D = visual_pivot.get_node_or_null("AnimatedSprite2D")
	if anim_sprite and anim_sprite.sprite_frames:
		var default_anim := "default"
		if anim_sprite.sprite_frames.has_animation(default_anim):
			return anim_sprite.sprite_frames.get_frame_texture(default_anim, 0)

	return null
