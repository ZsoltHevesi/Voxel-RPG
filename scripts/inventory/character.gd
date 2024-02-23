extends Control

@onready var dmg = %DMG

func calculate():
	var sum = 0
	
	for i in get_children():
		sum += i.get_DMG()
	
	dmg.text = str(sum)
