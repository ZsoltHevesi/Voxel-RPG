extends CharacterBody3D

@onready var camera_mount = $cameraMount
@onready var animation_player = $visuals/AnimationPlayer
@onready var animationTree = $visuals/AnimationTree
@onready var crosshair = $cameraMount/SpringArm3D/Camera3D/UI/crosshair

@onready var inv_head = $playerMenu/UI/character/headSlot/TextureRect
@onready var inv_torso = $playerMenu/UI/character/torsoSlot/TextureRect
@onready var inv_leftShoulder = $playerMenu/UI/character/leftShoulderSlot/TextureRect
@onready var inv_rightShoulder = $playerMenu/UI/character/rightShoulderSlot/TextureRect
@onready var inv_leftHand = $playerMenu/UI/character/leftHandSlot/TextureRect
@onready var inv_rightHand = $playerMenu/UI/character/rightHandSlot/TextureRect
@onready var inv_leftLeg = $playerMenu/UI/character/leftLegSlot/TextureRect
@onready var inv_rightLeg = $playerMenu/UI/character/rightLegSlot/TextureRect
@onready var inv_leftFoot = $playerMenu/UI/character/leftFootSlot/TextureRect
@onready var inv_rightFoot = $playerMenu/UI/character/rightFootSlot/TextureRect

@onready var default_head = load("res://scenes/player/playerGear_Scenes/armour/playerWinter/winter_Head.tscn")
@onready var default_torso = load("res://scenes/player/playerGear_Scenes/armour/playerWinter/winter_Torso.tscn")
@onready var default_leftShoulder = load("res://scenes/player/playerGear_Scenes/armour/playerWinter/winter_Left_Shoulder.tscn")
@onready var default_rightShoulder = load("res://scenes/player/playerGear_Scenes/armour/playerWinter/winter_Right_Shoulder.tscn")
@onready var default_leftHand = load("res://scenes/player/playerGear_Scenes/armour/playerWinter/winter_Left_Hand.tscn")
@onready var default_rightHand = load("res://scenes/player/playerGear_Scenes/armour/playerWinter/winter_Right_Hand.tscn")
@onready var default_leftLeg = load("res://scenes/player/playerGear_Scenes/armour/playerWinter/winter_Left_Leg.tscn")
@onready var default_rightLeg = load("res://scenes/player/playerGear_Scenes/armour/playerWinter/winter_Right_Leg.tscn")
@onready var default_leftFoot = load("res://scenes/player/playerGear_Scenes/armour/playerWinter/winter_Left_Foot.tscn")
@onready var default_rightFoot = load("res://scenes/player/playerGear_Scenes/armour/playerWinter/winter_Right_Foot.tscn")

@onready var pnHead = $visuals/pnTorso/pnHead
@onready var pnTorso = $visuals/pnTorso
@onready var pnLeftShoulder = $visuals/pnTorso/pnLeftShoulder
@onready var pnRightShoulder = $visuals/pnTorso/pnRightShoulder
@onready var pnLeftHand = $visuals/pnTorso/pnLeftShoulder/pnLeftHand
@onready var pnRightHand = $visuals/pnTorso/pnRightShoulder/pnRightHand
@onready var pnLeftLeg = $visuals/pnLeftFoot/pnLeftLeg
@onready var pnRightLeg = $visuals/pnRightFoot/pnRightLeg
@onready var pnLeftFoot = $visuals/pnLeftFoot
@onready var pnRightFoot = $visuals/pnRightFoot
@onready var longSword = $visuals/pnTorso/pnRightShoulder/pnRightHand/pnRightWeaponSlot/LongSword
@onready var weaponCast = $cameraMount/SpringArm3D/weaponCast

var bullet = load("res://scenes/player/bullet.tscn")
var bulletInstance
@onready var barrel = $visuals/pnTorso/pnLeftShoulder/pnLeftHand/pnLeftWeaponSlot/FlintlockPistol/barrel

# Player animation tree node paths
var idleWalkRun = "parameters/IdleWalkRunBlend/blend_amount"
var aimTransition = "parameters/aimTransition/transition_request"
var aimTransitionState = "parameters/aimTransition/current_state"
var weaponBlend = "parameters/weaponBlend/blend_amount"
var airGroundTransition = "parameters/airGroundTransition/transition_request"

var weaponBlendTarget = 0.0
var weaponCastTip = Vector3()

var SPEED = 5.5
var sprintSpeed = 9.0
var acceleration = 6
var JUMP_VELOCITY = 6 # Jump height y-axis
var airTime = 0

@export var mouseSensitivity = 0.3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# Variables for the player health
@onready var healthBar = $cameraMount/SpringArm3D/Camera3D/UI/HealthBar
var maxHealth = 100
var currentHealth = maxHealth


# Handle equipping armour
var instance
func equip_armour():
	# Equip head
	if inv_head.texture != null:
		pnHead.get_child(0).queue_free()
		instance = inv_head.item_scene.instantiate()
		pnHead.add_child(instance)
	else:
		pnHead.get_child(0).queue_free()
		instance = default_head.instantiate()
		pnHead.add_child(instance)
		
	# Equip torso
	if inv_torso.texture != null:
		pnTorso.get_child(3).queue_free()
		instance = inv_torso.item_scene.instantiate()
		pnTorso.add_child(instance)
	else:
		pnTorso.get_child(3).queue_free()
		instance = default_torso.instantiate()
		pnTorso.add_child(instance)
		
	# Equip Left Shoulder
	if inv_leftShoulder.texture != null:
		pnLeftShoulder.get_child(1).queue_free()
		instance = inv_leftShoulder.item_scene.instantiate()
		pnLeftShoulder.add_child(instance)
	else:
		pnLeftShoulder.get_child(1).queue_free()
		instance = default_leftShoulder.instantiate()
		pnLeftShoulder.add_child(instance)
	
	# Equip Right Shoulder
	if inv_rightShoulder.texture != null:
		pnRightShoulder.get_child(1).queue_free()
		instance = inv_rightShoulder.item_scene.instantiate()
		pnRightShoulder.add_child(instance)
	else:
		pnRightShoulder.get_child(1).queue_free()
		instance = default_rightShoulder.instantiate()
		pnRightShoulder.add_child(instance)
	
	# Equip Left Hand
	if inv_leftHand.texture != null:
		pnLeftHand.get_child(1).queue_free()
		instance = inv_leftHand.item_scene.instantiate()
		pnLeftHand.add_child(instance)
	else:
		pnLeftHand.get_child(1).queue_free()
		instance = default_leftHand.instantiate()
		pnLeftHand.add_child(instance)
	
	# Equip Right Hand
	if inv_rightHand.texture != null:
		pnRightHand.get_child(1).queue_free()
		instance = inv_rightHand.item_scene.instantiate()
		pnRightHand.add_child(instance)
	else:
		pnRightHand.get_child(1).queue_free()
		instance = default_rightHand.instantiate()
		pnRightHand.add_child(instance)
	
	# Equip Left Leg
	if inv_leftLeg.texture != null:
		pnLeftLeg.get_child(0).queue_free()
		instance = inv_leftLeg.item_scene.instantiate()
		pnLeftLeg.add_child(instance)
	else:
		pnLeftLeg.get_child(0).queue_free()
		instance = default_leftLeg.instantiate()
		pnLeftLeg.add_child(instance)
	
	# Equip Right Leg
	if inv_rightLeg.texture != null:
		pnRightLeg.get_child(0).queue_free()
		instance = inv_rightLeg.item_scene.instantiate()
		pnRightLeg.add_child(instance)
	else:
		pnRightLeg.get_child(0).queue_free()
		instance = default_rightLeg.instantiate()
		pnRightLeg.add_child(instance)
	
	# Equip Left Foot
	if inv_leftFoot.texture != null:
		pnLeftFoot.get_child(1).queue_free()
		instance = inv_leftFoot.item_scene.instantiate()
		pnLeftFoot.add_child(instance)
	else:
		pnLeftFoot.get_child(1).queue_free()
		instance = default_leftFoot.instantiate()
		pnLeftFoot.add_child(instance)
	
	# Equip Right Foot
	if inv_rightFoot.texture != null:
		pnRightFoot.get_child(1).queue_free()
		instance = inv_rightFoot.item_scene.instantiate()
		pnRightFoot.add_child(instance)
	else:
		pnRightFoot.get_child(1).queue_free()
		instance = default_rightFoot.instantiate()
		pnRightFoot.add_child(instance)


func takeDamage(amount):
	if amount < currentHealth:
		currentHealth -= amount
	else:
		currentHealth = 0
	print("Current Health:", currentHealth)
	healthBar.value = currentHealth
	if currentHealth <= 0:
		# Function to handle player death
		die()
		
func die():
	# Implementing logic for player death (death animations, resetting health etc.)
	currentHealth = maxHealth

func heal(amount):
	currentHealth += amount
	healthBar.value = currentHealth
	if currentHealth > maxHealth:
		currentHealth = maxHealth


# Capture Mouse
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Rotate Player and Camera
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(- event.relative.x * mouseSensitivity))
		camera_mount.rotate_x(deg_to_rad(- event.relative.y * mouseSensitivity))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(90))                                                                 

# Go down stairs
var maxStepDown = -0.51

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




func _physics_process(delta):
	
	if weaponCast.is_colliding() && (weaponCast.get_collision_point() - weaponCast.global_transform.origin).length() > 0.2:
		weaponCastTip = weaponCast.get_collision_point()
	else:
		weaponCastTip = (weaponCast.target_position.z * weaponCast.global_transform.basis.z) + weaponCast.global_transform.origin
	barrel.look_at(weaponCastTip)

	longSword.get_node("MeshInstance3D/longSwordHitBox").monitoring = false
	# Example: Check for player health and take damage if needed
	if Input.is_action_just_pressed("takeDamage"):
		# Amount of damage can be adjusted as needed
		takeDamage(20) 
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		airTime += delta
		if airTime > 0.05:
			animationTree.set(airGroundTransition, "inAir")
		
	if is_on_floor():
		airTime = 0
		animationTree.set(airGroundTransition, "onGround")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		# Handle Sprinting
		if Input.is_action_pressed("Sprint"):
			velocity.x = direction.x * sprintSpeed
			velocity.z = direction.z * sprintSpeed
			animationTree.set(idleWalkRun, lerp(animationTree.get(idleWalkRun), 1.0, delta * acceleration))
			
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			animationTree.set(idleWalkRun, lerp(animationTree.get(idleWalkRun), 0.0, delta * acceleration))

	else:
		velocity.x = move_toward(velocity.x, 0, (sprintSpeed if Input.is_action_pressed("Sprint") else SPEED))
		velocity.z = move_toward(velocity.z, 0, (sprintSpeed if Input.is_action_pressed("Sprint") else SPEED))
		animationTree.set(idleWalkRun, lerp(animationTree.get(idleWalkRun), -1.0, delta * acceleration))
	
	
	if Input.is_action_pressed("attack") and !Input.is_action_pressed("aim") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and is_on_floor():
		animationTree.set("parameters/weaponOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		longSword.get_node("MeshInstance3D/longSwordHitBox").monitoring = true
	
	# Handle aiming
	if Input.is_action_pressed("aim") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and is_on_floor():
		if animationTree.get(aimTransitionState) == "notAiming":
			animationTree.set(aimTransition, "aiming")
			weaponBlendTarget = 1.0
			crosshair.visible = true
		if Input.is_action_just_pressed("attack"):
			bulletInstance = bullet.instantiate()
			bulletInstance.position = barrel.global_position
			bulletInstance.transform.basis = barrel.global_transform.basis
			get_parent().add_child(bulletInstance)
			animationTree.set("parameters/shootOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		if animationTree.get(aimTransitionState) == "aiming":
			animationTree.set(aimTransition, "notAiming")
			weaponBlendTarget = 0.0
			crosshair.visible = false
	animationTree.set(weaponBlend, lerp(float(animationTree.get(weaponBlend)), weaponBlendTarget, delta * 5))

	_rotate_sep_ray() # call this before move_and_slide()
	move_and_slide()
	_snap_down_stairs_check()
	
func _on_Fallbarrier_body_entered(body):
			if body.name == "Player":
				# Reduce player's health
				takeDamage(currentHealth)

