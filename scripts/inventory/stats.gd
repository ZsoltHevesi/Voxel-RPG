extends TextureRect

# Slot type
@export var slot_type: int = 0

# Setter variable for Attack damage
@export var dmg = 0:
	set(value):
		dmg = value
		%debug.text = str(dmg)

# Dictionary for properties
@onready var property: Dictionary = {"TEXTURE": texture,
									 "DMG": dmg,
									 "SLOT_TYPE": slot_type}:
	set(value):
		property = value
		
		# Update properties
		texture = property["TEXTURE"]
		dmg = property["DMG"]
		slot_type = property["SLOT_TYPE"]
