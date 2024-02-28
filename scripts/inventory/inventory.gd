extends GridContainer


func add_item(ID = "0"):
	# Access item data
	var item_texture = load("res://assets/textures/" + ItemData.get_texture(ID))
	var item_scene = load("res://scenes/player/playerGear_Scenes/" + ItemData.get_scene(ID))
	
	var item_slot_type = ItemData.get_slot_type(ID)
	var item_dmg = ItemData.get_dmg(ID)
	
	
	var item_data = {"TEXTURE": item_texture,
					 "DMG": item_dmg,
					 "SLOT_TYPE": item_slot_type,
					 "ITEM_SCENE": item_scene}
	
	# Traverse through all slots
	var index = 0
	for i in get_children():
		if i.filled == false:
			index = i.get_index() # Get index of first unfilled slot
			break
		
	# Add item to that index
	get_child(index).set_property(item_data)
