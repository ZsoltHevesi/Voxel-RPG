extends CharacterBody3D

var speed = 6
var accel = 10
var chaseRange = 15
@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var player = $"../Player"

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


func _ready():

	if player:
		print("Player assigned successfully.")
	else:
		print("Player not found or assigned.")

func _physics_process(delta):
	# Example: Check for player health and take damage if needed
	if Input.is_action_just_pressed("takeDamage"):
		# Amount of damage can be adjusted as needed
		takeDamage(20) 
		
		
	# AI pathfinding logic
	if player:

		var distanceToPlayer = global_position.distance_to(player.global_position)
		

		if distanceToPlayer <= chaseRange:

			nav.target_position = player.global_transform.origin
			
			# Calculate direction towards the player
			var direction = nav.target_position - global_position
			direction = direction.normalized()
			
			# Apply movement
			velocity = velocity.lerp(direction * speed, accel * delta)
			
			move_and_slide()
			
			look_at(player.global_transform.origin, Vector3.UP)
		else:
			# If the player is outside the chase range, stop moving
			velocity = Vector3.ZERO
	else:
		print("Player not assigned or found.")
