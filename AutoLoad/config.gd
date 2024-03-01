extends Node

var config = ConfigFile.new()

func _ready():
	var err = config.load("user://config.cfg")
	if err != OK:
		return
	get_window().set_size(Vector2i(config.get_value("options", "resolution_width"), config.get_value("options", "resolution_height")))
	
	if config.get_value("options", "fullscreen"):
		get_window().set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
	
	if config.get_value("options", "vsync"):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
