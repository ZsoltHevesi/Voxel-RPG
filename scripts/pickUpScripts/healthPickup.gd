extends Node3D

@export var healAmount = 10

# If player enters, add item to inventory
func _on_body_entered(body):
	body.heal(healAmount)
	queue_free()
