extends CharacterBody3D

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
		

func _physics_process(delta):
	# Example: Check for player health and take damage if needed
	if Input.is_action_just_pressed("takeDamage"):
		# Amount of damage can be adjusted as needed
		takeDamage(20) 
