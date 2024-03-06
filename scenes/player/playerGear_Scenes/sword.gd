extends Node3D


func _on_hit_box_area_entered(area):
	if area.is_in_group("enemies") and area.get_parent().meleeImmunity == false:
		area.get_parent().currentHealth -= 50
		area.get_parent().meleeImmunity = true
		print("area entered")
