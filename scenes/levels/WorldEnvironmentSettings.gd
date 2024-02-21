extends WorldEnvironment


func _ready():
	if Graphics.ssao == 1:
		environment.ssao_enabled = true
	else:
		environment.ssao_enabled = false

	if Graphics.glow == 1:
		environment.glow_enabled = true
	else:
		environment.glow_enabled = false

	ProjectSettings.set_setting("rendering/scaling_3d/scale", Graphics.scaling)
