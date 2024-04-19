extends Label
@onready var fpsMeter = $"."

var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var err = config.load("user://config.cfg")
	if err != OK:
		return
	if config.get_value("options", "fps_counter"):
		fpsMeter.show()
	else:
		fpsMeter.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var fps = Engine.get_frames_per_second()
	text = "FPS: " + str(fps)
