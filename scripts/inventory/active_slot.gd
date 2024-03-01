extends Slot
class_name ActiveSlot

func _can_drop_data(_pos, data):
	return data is TextureRect and data.slot_type == slot_type
