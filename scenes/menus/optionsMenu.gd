extends Control


func _on_shadow_toggle_toggled(toggled_on):
	if toggled_on:
		Graphics.shadows = 1
	else:
		Graphics.shadows = 0

func _on_ssao_toggle_toggled(toggled_on):
	if toggled_on:
		Graphics.ssao = 1
	else:
		Graphics.ssao = 0

func _on_glow_toggle_toggled(toggled_on):
	if toggled_on:
		Graphics.glow = 1
	else:
		Graphics.glow = 0


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/mainMenu.tscn")
