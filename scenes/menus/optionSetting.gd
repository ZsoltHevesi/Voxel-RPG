extends VBoxContainer

@onready var resolutionList = $resolutionList

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
								"3840x2160" : Vector2i(3840, 2160),
								"5120x1440" : Vector2i(5120, 1440)}


func _ready():
	addResolutions()


func addResolutions():
	for r in resolutions:
		resolutionList.add_item(r)


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
