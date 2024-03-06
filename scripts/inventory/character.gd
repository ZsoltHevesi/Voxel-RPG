extends Control

@onready var dmg = %DMG
@onready var def = %DEF



func calculate_def():
	var sumDEF = 0
	
	for i in get_children():
		sumDEF += i.get_DEF()
	
	def.text = str(sumDEF)


func calculate_dmg():
	var sumDMG = 0
	
	for i in get_children():
		sumDMG += i.get_DMG()
	
	dmg.text = str(sumDMG)
