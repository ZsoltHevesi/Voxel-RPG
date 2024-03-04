extends Node3D


const speed = 40.0
@onready var mesh = $MeshInstance3D
@onready var hitParticles = $hitParticles
@onready var bulletCast = $bulletCast
@onready var bulletDamage = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if bulletCast.is_colliding() == false:
		position += transform.basis * Vector3(0, 0, speed) * delta
	else:
		hitParticles.global_position = bulletCast.get_collision_point()
		hitParticles.emitting = true
		mesh.visible = false
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_timer_timeout():
	queue_free()


func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("enemies"):
		area.get_parent().currentHealth -= bulletDamage
