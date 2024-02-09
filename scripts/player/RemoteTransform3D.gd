extends RemoteTransform3D

var parent_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	parent_rotation = get_parent().rotation
	set_rotation(- parent_rotation)
