extends VBoxContainer

@onready var resolutionList = $resolutionBox/resolutionList
@onready var fullscreenCheckBox = $fullscreenBox/fullscreenCheckBox
@onready var scalingLabel = $scaleBox/scalingLabel
@onready var scalingSlider = $scaleBox/scalingSlider
@onready var scaleBox = $scaleBox
@onready var fsrOptions = $fsrOptions
@onready var vsyncCheckBox = $vsyncBox/vsyncCheckBox

var config = ConfigFile.new()

var resolutions : Dictionary = {"1440x900" : Vector2i(1440, 900),
								"1600x900" : Vector2i(1600, 900),
								"1680x1050" : Vector2i(1600, 1050),
								"1920x1080" : Vector2i(1920, 1080),
								"1920x1200" : Vector2i(1920, 1200),
								"2560x1080" : Vector2i(2560, 1080),
								"2560x1440" : Vector2i(2560, 1440),
								"2560x1600" : Vector2i(2560, 1600),
								"2880x1800" : Vector2i(2880, 1800),
								"3440x1440" : Vector2i(3440, 1440),
								"3072x1920" : Vector2i(3072, 1920),
								"3840x2160" : Vector2i(3840, 2160),
								"5120x1440" : Vector2i(5120, 1440)}


func _ready():
	addResolutions()
	var err = config.load("user://config.cfg")
	if err != OK:
		return


func addResolutions():
	var currentResolution = get_window().get_size()
	var id = 0
	for r in resolutions:
		resolutionList.add_item(r)
		if resolutions[r] == currentResolution:
			resolutionList.select(id)
		id += 1


func _on_resolution_list_item_selected(index):
	var id = resolutionList.get_item_text(index)
	get_window().set_size(resolutions[id])
	centerScreen()


func centerScreen():
	var screenCenter = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var windowSize = get_window().get_size_with_decorations()
	get_window().set_position(screenCenter - windowSize/2)


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/mainMenu.tscn")
	config.save("user://config.cfg")


func _on_fullscreen_check_box_toggled(toggled_on):
	resolutionList.set_disabled(toggled_on)
	if toggled_on:
		get_window().set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)


func _on_scaling_slider_value_changed(value):
	var resolutionScale = value/100.00
	var resolutionText = str(round(get_window().get_size().x * resolutionScale)) + "x" + str(round(get_window().get_size().y * resolutionScale))
	
	scalingLabel.set_text(str(value)+"% - " + resolutionText)
	get_viewport().set_scaling_3d_scale(resolutionScale)


func _on_scaling_mode_item_selected(index):
	var getViewport = get_viewport()
	match index:
		0:
			scaleBox.hide()
			scalingSlider.set_editable(false)
			fsrOptions.hide()
		1:
			getViewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_BILINEAR)
			scaleBox.show()
			scalingSlider.set_editable(true)
			fsrOptions.hide()
		2:
			getViewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_FSR)
			scaleBox.hide()
			scalingSlider.set_editable(false)
			fsrOptions.show()
		3:
			getViewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_FSR2)
			scaleBox.hide()
			scalingSlider.set_editable(false)
			fsrOptions.show()


func _on_fsr_options_item_selected(index):
	match index:
		1:
			_on_scaling_slider_value_changed(50.00)
		2:
			_on_scaling_slider_value_changed(59.00)
		3:
			_on_scaling_slider_value_changed(67.00)
		4:
			_on_scaling_slider_value_changed(77.00)


func _on_vsync_check_box_toggled(toggled_on):
		if toggled_on:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			config.set_value("options", "vsync", true)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			config.set_value("options", "vsync", false)

func _on_shadow_toggle_toggled(toggled_on):
	if toggled_on:
		config.set_value("options", "shadows", true)
	else:
		config.set_value("options", "shadows", false)


func _on_ssao_toggle_toggled(toggled_on):
	if toggled_on:
		config.set_value("options", "ssao", true)
	else:
		config.set_value("options", "ssao", false)


func _on_glow_toggle_toggled(toggled_on):
	if toggled_on:
		config.set_value("options", "glow", true)
	else:
		config.set_value("options", "glow", false)
