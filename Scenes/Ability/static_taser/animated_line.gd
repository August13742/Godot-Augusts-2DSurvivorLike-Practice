extends Line2D


@export var spritesheet_columns = 4
@export var spritesheet_rows = 4

@export var target_animation_fps: int = 30


var current_frame:int = 0
var TOTAL_FRAMES = spritesheet_columns * spritesheet_rows

func _ready():
	material.set_shader_parameter("columns", spritesheet_columns)
	material.set_shader_parameter("rows", spritesheet_rows)
	
var accumulated_time: float = 0.0
func _process(delta: float) -> void:
	accumulated_time += delta
	var frame_duration := 1.0 / target_animation_fps
	
	while accumulated_time >= frame_duration:
		accumulated_time -= frame_duration
		current_frame = (current_frame + 1) % TOTAL_FRAMES
		material.set_shader_parameter("frame", current_frame)
