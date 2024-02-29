extends Control

func _input(event):
	if event.is_action_pressed("inventory"):
		toggle_inventory_interface()


func toggle_inventory_interface():
	visible = !visible
	
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
