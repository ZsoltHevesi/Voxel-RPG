extends Node3D

func _ready():
	pass

func _physics_process(delta):
	if get_tree().has_group("enemies") == false:
		get_node("../Player").win = true
