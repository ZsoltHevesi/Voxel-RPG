extends Node3D

func _on_long_sword_hit_box_area_entered(area):
	if area.is_in_group("enemy"):
		area.get_parent().currentHealth -= 20
		await get_tree().create_timer(1.0).timeout
