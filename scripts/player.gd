extends CharacterBody3D

@onready var camera_mount = $cameraMount

var SPEED = 5.0
var sprintSpeed = 9.0
var JUMP_VELOCITY = 6 # Jump height y-axis

@export var mouseSensitivity = 0.3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var maxStepDown = -0.51


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
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

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
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, (sprintSpeed if Input.is_action_pressed("Sprint") else SPEED))
		velocity.z = move_toward(velocity.z, 0, (sprintSpeed if Input.is_action_pressed("Sprint") else SPEED))


	move_and_slide()
	_snap_down_stairs_check()
