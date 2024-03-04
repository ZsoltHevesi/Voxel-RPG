extends Node

var config = ConfigFile.new()

func _ready():
	var err = config.load("user://config.cfg")
	if err != OK:
		config.set_value("options", "fullscreen", false)
		config.set_value("options", "vsync", true)
		config.set_value("options", "ssao", true)
		config.set_value("options", "glow", true)
		config.set_value("options", "scaling_mode", 1)
		config.set_value("options", "scaling_value", 100.00)
		config.set_value("options", "resolution_width", 1920)
		config.set_value("options", "resolution_height", 1080)
		config.set_value("options", "fsr", 0)
		config.set_value("options", "shadows", true)
		config.save("user://config.cfg")
	err = config.has_section_key("options", "fullscreen")
	if err != true:
		config.set_value("options", "fullscreen", false)
	err = config.has_section_key("options", "vsync")
	if err != true:
		config.set_value("options", "vsync", true)
	err = config.has_section_key("options", "ssao")
	if err != true:
		config.set_value("options", "ssao", true)
	err = config.has_section_key("options", "glow")
	if err != true:
		config.set_value("options", "glow", true)
	err = config.has_section_key("options", "scaling_mode")
	if err != true:
		config.set_value("options", "scaling_mode", 1)
	err = config.has_section_key("options", "scaling_value")
	if err != true:
		config.set_value("options", "scaling_value", 100.00)
	err = config.has_section_key("options", "resolution_width")
	if err != true:
		config.set_value("options", "resolution_width", 1920)
	err = config.has_section_key("options", "resolution_height")
	if err != true:
		config.set_value("options", "resolution_height", 1080)
	err = config.has_section_key("options", "fsr")
	if err != true:
		config.set_value("options", "fsr", 0)
	err = config.has_section_key("options", "shadows")
	if err != true:
		config.set_value("options", "shadows", true)
	config.save("user://config.cfg")
	get_window().set_size(Vector2i(config.get_value("options", "resolution_width"), config.get_value("options", "resolution_height")))
	
	if config.get_value("options", "fullscreen"):
		get_window().set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
	
	if config.get_value("options", "vsync"):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
