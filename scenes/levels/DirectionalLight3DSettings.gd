extends DirectionalLight3D

func _ready():
	if Graphics.shadows == 1:
		shadow_enabled = true
	else:
		shadow_enabled = false
