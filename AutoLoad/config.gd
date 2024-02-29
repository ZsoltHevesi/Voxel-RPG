extends Node


func _ready():
	var config = ConfigFile.new()
	config.set_value("options", "vsync", true)
	config.set_value("options", "shadows", true)
	config.set_value("options", "ssao", true)
	config.set_value("options", "glow", true)
	config.save("user://config.cfg")
