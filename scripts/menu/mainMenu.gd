extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level1/level1.tscn")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/optionsMenu.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
