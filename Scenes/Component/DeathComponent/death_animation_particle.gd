extends GPUParticles2D
class_name DeathAnimationParticleScene


@export var sprite_texture:Texture2D
@onready var timer:Timer = $Timer


func _ready():
	print("particle called")
	texture = sprite_texture
	#animation.finished.connect(on_animation_finish)   #(gd 4.4.1)this is buggy, doesn't actually emit when lifetime is finished
	timer.timeout.connect(on_animation_finish)
	emitting = true
	timer.start(lifetime)
	

	
func on_animation_finish():
	print("particle finished")
	queue_free()
	
	
