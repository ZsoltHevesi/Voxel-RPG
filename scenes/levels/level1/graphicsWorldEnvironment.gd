extends WorldEnvironment

@onready var config = ConfigFile.new()

func _ready():
	config.load("user://config.cfg")
	environment.ssao_enabled = config.get_value("options", "ssao")
	environment.glow_enabled = config.get_value("options", "glow")
	environment.adjustment_brightness = config.get_value("options", "brightness")
