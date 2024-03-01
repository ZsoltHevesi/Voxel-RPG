extends TextureRect

# Slot type
@export var slot_type: int = 0
var item_scene

# Setter variable for Attack damage
@export var dmg = 0:
	set(value):
		dmg = value
		%debug.text = str(dmg)
		
		# Calculate for any change in DMG, in PassiveSlot
		if get_parent() is PassiveSlot:
			get_parent().get_parent().calculate()

# Dictionary for properties
@onready var property: Dictionary = {"TEXTURE": texture,
									 "DMG": dmg,
									 "SLOT_TYPE": slot_type,
									 "ITEM_SCENE": item_scene}:
	set(value):
		property = value
		
		# Update properties
		texture = property["TEXTURE"]
		dmg = property["DMG"]
		slot_type = property["SLOT_TYPE"]
		item_scene = property["ITEM_SCENE"]
