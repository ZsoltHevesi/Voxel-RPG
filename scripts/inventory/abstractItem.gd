extends Node3D

@export var ID = "0"


func _ready():
	var scene = load("res://scenes/player/playerGear_Scenes/" + ItemData.get_scene(ID))
	var instance = scene.instantiate()
	
	add_child(instance)

# If player enters, add item to inventory
func _on_body_entered(body):
	get_parent().get_node("Player/playerMenu/UI/inventory").add_item(ID)
	queue_free()
