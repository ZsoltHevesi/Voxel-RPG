extends Node3D

@export var ID = "0"

# If player enters, add item to inventory
func _on_body_entered(body):
	get_parent().find_child("Inventory").add_item(ID)
	queue_free()
