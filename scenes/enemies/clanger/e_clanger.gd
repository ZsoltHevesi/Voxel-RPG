extends CharacterBody3D

var speed = 5
var accel = 10
var chaseRange = 20
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var player = $"../Player"
@onready var clanger = $"."

var maxHealth = 100
var currentHealth = maxHealth

var lootInstance
var loot = load("res://scenes/pickUp_Items/pickUp_abstractItem.tscn")
var lootPool = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]

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
		
func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		body.call("takeDamage", 10)  # Adjust the amount of damage as needed


func _ready():

	if player:
		print("Player assigned successfully.")
	else:
		print("Player not found or assigned.")

# Define a separate maximum height value
var maxEnemyHeight = 0.5

func _physics_process(delta):
	# AI pathfinding logic
	if player:
		var distanceToPlayer = global_position.distance_to(player.global_position) - 1.0
		
		if distanceToPlayer <= chaseRange:
			# Calculate direction towards the player
			var direction = player.global_transform.origin - global_position
			direction.y = 0  
			
			if direction.length() > 0:
				direction = direction.normalized()
			
			# Set the desired distance from the player
			var desiredDistance = 2
			

			var targetPosition = player.global_transform.origin - direction * desiredDistance
			
			# Apply movement
			velocity = velocity.lerp((targetPosition - global_position).normalized() * speed, accel * delta)
			
			_rotate_sep_ray()
			move_and_slide()
			_snap_down_stairs_check()
			
			# Limit enemy height
			var minHeight = global_position.y -1
			var maxHeight = global_position.y + maxEnemyHeight 
			
			if global_position.y < minHeight:
				global_position.y = minHeight
			elif global_position.y > maxHeight:
				global_position.y = maxHeight 
			
			look_at(player.global_transform.origin, Vector3.UP)
		else:
			# If the player is outside the chase range, stop moving
			velocity = Vector3.ZERO
	else:
		print("Player not assigned or found.")
		





func _on_hit_box_area_entered(area):
	if area.is_in_group("playerWeapon"):
		lootInstance = loot.instantiate()
		lootInstance.ID = lootPool[randi() % lootPool.size()]
		lootInstance.position = clanger.position
		get_parent().add_child(lootInstance)
		queue_free()
