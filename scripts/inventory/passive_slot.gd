extends Slot
class_name PassiveSlot

@onready var parentNode = find_parent("Player")

# Override _can_drop_data() to check slot type too
func _can_drop_data(_pos, data):
	return data is TextureRect and data.slot_type == slot_type
	
func _drop_data(_pos, data):
	var temp = texture_rect.property
	texture_rect.property = data.property
	data.property = temp

	parentNode.equip_armour()
