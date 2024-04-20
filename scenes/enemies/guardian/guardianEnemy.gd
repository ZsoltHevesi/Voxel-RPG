extends CharacterBody3D

@onready var navAgent = $NavigationAgent3D
@onready var guardian = $"."
@onready var player = get_tree().get_root().get_node("world/Player")
@onready var hit_box = $visuals/pnTorso/pnRightShoulder/pnRightHand/pnRightWeaponSlot/longSwordMagic/MeshInstance3D/hitBox

# Vars for animation related nodes
@onready var animation_player = $visuals/AnimationPlayer
@onready var animationTree = $visuals/AnimationTree

var attackAnimFinished = true

# Player animation tree node paths
var idleWalkRun = "parameters/IdleWalkRunBlend/blend_amount"
var aimTransition = "parameters/aimTransition/transition_request"
var aimTransitionState = "parameters/aimTransition/current_state"
var weaponBlend = "parameters/weaponBlend/blend_amount"
var airGroundTransition = "parameters/airGroundTransition/transition_request" 

@export var enemyDamage = 20

var lootInstance
var loot = load("res://scenes/pickUp_Items/pickUp_abstractItem.tscn")
var lootPool = ["12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "26"]


var chaseRange = 40
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var SPEED = 5.0
var desiredDistance = 1.25
var maxHealth = 500
@export var currentHealth = maxHealth
var meleeImmunity = false

# Go down stairs
var maxStepDown = -0.51

var attack_range = Vector3(15, 15, 15)


var _on_floor_last_frame = false
var _snapped_to_stairs_last_frame = false
func _snap_down_stairs_check():
	var did_snap = false
	
	if not is_on_floor() and velocity.y <= 0 and (_on_floor_last_frame or _snapped_to_stairs_last_frame) and $checkStairsRayCast.is_colliding():
		var bodyTestResult = PhysicsTestMotionResult3D.new()
		var params = PhysicsTestMotionParameters3D.new()
		
		params.from = self.global_transform
		params.motion = Vector3(0, maxStepDown, 0)
		
		if PhysicsServer3D.body_test_motion(self.get_rid(), params, bodyTestResult):
			var translate_y = bodyTestResult.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	
	_on_floor_last_frame = is_on_floor()
	_snapped_to_stairs_last_frame = did_snap

# Rotate separation rays in direction of velocity
@onready var _initial_sep_ray_dist = abs($sepRayFront.position.z)
var _last_xz_vel : Vector3 = Vector3(0,0,0)
func _rotate_sep_ray():
	var xz_vel = velocity * Vector3(1,0,1)
	
	# Keep separation ray in same position after stopping
	if xz_vel.length() < 0.1:
		xz_vel = _last_xz_vel
	else:
		_last_xz_vel = xz_vel
	
	# Rotate front separation ray in direction of player velocity
	var xz_front_ray_pos = xz_vel.normalized() * _initial_sep_ray_dist
	$sepRayFront.global_position.x = self.global_position.x + xz_front_ray_pos.x
	$sepRayFront.global_position.z = self.global_position.z + xz_front_ray_pos.z
	
	# Rotate remaining separation rays relative to sepRayFront
	var xz_left_ray_pos = xz_front_ray_pos.rotated(Vector3(0,1.0,0), deg_to_rad(-50))
	$sepRayLeft.global_position.x = self.global_position.x + xz_left_ray_pos.x
	$sepRayLeft.global_position.z = self.global_position.z + xz_left_ray_pos.z
	
	var xz_right_ray_pos = xz_front_ray_pos.rotated(Vector3(0,1.0,0), deg_to_rad(50))
	$sepRayRight.global_position.x = self.global_position.x + xz_right_ray_pos.x
	$sepRayRight.global_position.z = self.global_position.z + xz_right_ray_pos.z
	
	var xz_fl_ray_pos = xz_front_ray_pos.rotated(Vector3(0,1.0,0), deg_to_rad(25))
	$sepRayFL.global_position.x = self.global_position.x + xz_fl_ray_pos.x
	$sepRayFL.global_position.z = self.global_position.z + xz_fl_ray_pos.z
	
	var xz_fr_ray_pos = xz_front_ray_pos.rotated(Vector3(0,1.0,0), deg_to_rad(-25))
	$sepRayFR.global_position.x = self.global_position.x + xz_fr_ray_pos.x
	$sepRayFR.global_position.z = self.global_position.z + xz_fr_ray_pos.z

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if currentHealth <= 0:
		die()
	# AI pathfinding
	var distanceToPlayer = global_position.distance_to(player.global_position) - 1.0
	if distanceToPlayer > chaseRange:
		animationTree.set(idleWalkRun, lerp(animationTree.get(idleWalkRun), -1.0, delta * SPEED))
	if distanceToPlayer <= chaseRange and position.distance_to(player.global_position) > desiredDistance:
		var currentLocation = global_transform.origin
		var nextLocation = navAgent.get_next_path_position()
		var newVelocity = (nextLocation - currentLocation).normalized() * SPEED
		animationTree.set(idleWalkRun, lerp(animationTree.get(idleWalkRun), 0.0, delta * SPEED))
		
		navAgent.set_velocity(newVelocity)
		
		# Rotate enemy to face player
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	else:
		navAgent.set_velocity(Vector3.ZERO)


func die():
		lootInstance = loot.instantiate()
		lootInstance.ID = lootPool[randi() % lootPool.size()]
		lootInstance.position = guardian.position
		get_parent().add_child(lootInstance)
		queue_free()

func update_target_location(target_location):
	navAgent.set_target_position(target_location)


func _on_navigation_agent_3d_target_reached():
	if attackAnimFinished == true:
		animationTree.set("parameters/weaponOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		hit_box.monitoring = true
		attackAnimFinished = false


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	
	_rotate_sep_ray() # call this before move_and_slide()
	move_and_slide()
	_snap_down_stairs_check()



func _on_guardian_hitbox_area_exited(area):
	if area.is_in_group("playerMeleeWeapon"):
		meleeImmunity = false


func _on_animation_tree_animation_finished(swordAttack1):
	attackAnimFinished = true
	hit_box.monitoring = false


func _on_hit_box_body_entered(body):
	if body.name == "Player":
		# Deal damage to the player
		body.takeDamage(enemyDamage)
