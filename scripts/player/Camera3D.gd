extends Camera3D

@onready var target: Object = get_parent().get_node("Player")
@export var smooth_speed: float
@export  var offset: Vector3
# Called when the node enters the scene tree for the first time.





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta:float) -> void:
	if(target!=null):
		self.transfrom.origin = lerp(self.transform.origin, target.tranform + offset, smooth_speed * delta, )
