extends CharacterBody2D


@export var vitesse_marche = 500.0
@export var vitesse_course = 750.0
@export_range(0, 1) var acceleration = 0.2
@export_range(0, 1) var deceleration = 0.2

@export var force_saut = -600
@export_range(0, 1) var deceleration_saut_relacher = 0.5



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("saut") and (is_on_floor() or is_on_wall()):
		velocity.y = force_saut
	
	if Input.is_action_just_released("saut") and velocity.y < 0:
		velocity.y *= deceleration_saut_relacher
	
	var vitesse
	if Input.is_action_pressed("course"):
		vitesse = vitesse_course
	else:
		vitesse = vitesse_marche
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("gauche", "droite")
	if direction:
		velocity.x = move_toward(velocity.x ,direction * vitesse, vitesse * acceleration )
	else:
		velocity.x = move_toward(velocity.x, 0, vitesse_marche * deceleration)

	move_and_slide()
