extends Node3D
@onready var player = $Player

'''
@onready var chateau = $map/NavigationRegion3D/tiles/Chateau
@onready var block = load("res://scenes/tiles/hallways/hallway1/hallwayCastle1.tscn")
@onready var blockInstance
@onready var exits : Dictionary = { 1 : $map/NavigationRegion3D/tiles/Chateau/exitCast1,
									2 : $map/NavigationRegion3D/tiles/Chateau/exitCast2,
									3 : $map/NavigationRegion3D/tiles/Chateau/exitCast3}
'''
func _ready():
	'''
	var chateauExit = exits.values()[randi() % exits.size()]
	blockInstance = block.instantiate()
	blockInstance.position = Vector3(chateauExit.global_position.x - blockInstance.get_node("exitCast1").position.x, chateauExit.global_position.y - blockInstance.get_node("exitCast1").position.y, chateauExit.global_position.z)
	blockInstance.transform.basis = chateauExit.global_transform.basis
	add_child(blockInstance)
	'''

func _physics_process(delta):
		get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
