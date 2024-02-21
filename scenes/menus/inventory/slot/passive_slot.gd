extends Slot
class_name PassiveSlot

# Override _can_drop_data() to check slot type too
func _can_drop_data(_pos, data):
	return data is TextureRect and data.slot_type == slot_type
