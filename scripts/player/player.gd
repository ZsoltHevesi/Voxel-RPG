extends CharacterBody3D

@onready var camera_mount = $cameraMount
@onready var animation_player = $visuals/AnimationPlayer
@onready var animationTree = $visuals/AnimationTree

# Player animation tree node paths
var idleWalkRun = "parameters/IdleWalkRunBlend/blend_amount"
var aimTransition = "parameters/aimTransition/transition_request"
var aimTransitionState = "parameters/aimTransition/current_state"
var weaponBlend = "parameters/weaponBlend/blend_amount"
var airGroundTransition = "parameters/airGroundTransition/transition_request"

var weaponBlendTarget = 0.0

var SPEED = 6.0
var sprintSpeed = 10.0
var acceleration = 6
var JUMP_VELOCITY = 6 # Jump height y-axis

@export var mouseSensitivity = 0.3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var maxStepDown = -0.51


# Variables for the player health
var maxHealth = 100
var currentHealth = maxHealth

func takeDamage(amount):
	currentHealth -= amount
	if currentHealth <= 0:
		# Function to handle player death
		die()
		
func die():
	# Implementing logic for player death (death animations, resetting health etc.)
	currentHealth = maxHealth

func heal(amount):
	currentHealth += amount
	if currentHealth > maxHealth:
		currentHealth = maxHealth


# Capture Mouse
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Rotate Player and Camera
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(- event.relative.x * mouseSensitivity))
		camera_mount.rotate_x(deg_to_rad(- event.relative.y * mouseSensitivity))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(90))


# Go down stairs
var _on_floor_last_frame = false
func _snap_down_stairs_check():
	if not is_on_floor() and velocity.y <= 0 and _on_floor_last_frame:
		var bodyTestResult = PhysicsTestMotionResult3D.new()
		var params = PhysicsTestMotionParameters3D.new()
		
		params.from = self.global_transform
		params.motion = Vector3(0, maxStepDown, 0)
		
		if PhysicsServer3D.body_test_motion(self.get_rid(), params, bodyTestResult):
			var translate_y = bodyTestResult.get_travel().y
			self.position.y += translate_y
	
	_on_floor_last_frame = is_on_floor()


func _physics_process(delta):

	# Example: Check for player health and take damage if needed
	if Input.is_action_just_pressed("takeDamage"):
		# Amount of damage can be adjusted as needed
		takeDamage(20) 
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		animationTree.set(airGroundTransition, "inAir")
		
	if is_on_floor():
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
	
	# Handle aiming
	if Input.is_action_pressed("aim"):
		if animationTree.get(aimTransitionState) == "notAiming":
			animationTree.set(aimTransition, "aiming")
			weaponBlendTarget = 1.0
		if Input.is_action_just_pressed("attack"):
			animationTree.set("parameters/shootOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		if animationTree.get(aimTransitionState) == "aiming":
			animationTree.set(aimTransition, "notAiming")
			weaponBlendTarget = 0.0
	animationTree.set(weaponBlend, lerp(float(animationTree.get(weaponBlend)), weaponBlendTarget, delta * 5))

	move_and_slide()
	_snap_down_stairs_check()
 # Camera movement logic


