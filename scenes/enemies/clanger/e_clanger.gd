extends CharacterBody3D

var speed = 5
var accel = 15
var JUMP_VELOCITY = 6 # Jump height y-axis

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var player = $"../Player"

func _ready():
	# Assuming the player is assigned under the name "Player" in the editor
	if player:
		print("Player assigned successfully.")
	else:
		print("Player not found or assigned.")

func _physics_process(delta):
	
	
#AI pathfinding logic
	if player:
		# Set the player's position as the target position for navigation
		nav.target_position = player.global_transform.origin
		
		# Calculate direction towards the player
		var direction = nav.target_position - global_position
		direction = direction.normalized()
		
		# Apply movement
		velocity = velocity.lerp(direction * speed, accel * delta)
			
		move_and_slide()
		
		look_at(player.global_transform.origin, Vector3.UP)
		
	else:
		print("Player not assigned or found.")
