extends DirectionalLight3D

@onready var config = ConfigFile.new()

func _ready():
	config.load("user://config.cfg")
	shadow_enabled = config.get_value("options", "shadows")
