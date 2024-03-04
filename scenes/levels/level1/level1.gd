extends Node3D

@onready var player = $map/Player


func _physics_process(delta):
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
