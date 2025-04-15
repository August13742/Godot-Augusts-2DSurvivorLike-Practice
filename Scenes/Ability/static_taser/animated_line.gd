extends Line2D


@export var spritesheet_columns = 4
@export var spritesheet_rows = 4

var current_frame:int = 0
var TOTAL_FRAMES = spritesheet_columns * spritesheet_rows

func _ready():
	material.set_shader_parameter("columns", spritesheet_columns)
	material.set_shader_parameter("rows", spritesheet_rows)

func _process(delta):
	current_frame = int((Time.get_ticks_msec() / 50) % TOTAL_FRAMES)
	material.set_shader_parameter("frame", current_frame)
