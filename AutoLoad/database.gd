extends Node

var content : Dictionary

func _ready():
	var file = FileAccess.open("res://database/database.json", FileAccess.READ)
	
	content = JSON.parse_string(file.get_as_text())
	
	file.close


func get_texture(ID = "0"):
	return content[ID]["texture"]

func get_dmg(ID = "0"):
	return content[ID]["dmg"]
	
func get_slot_type(ID = "0"):
	return content[ID]["slot_type"]
	
func get_scene(ID = "0"):
	return content[ID]["item_scene"]
