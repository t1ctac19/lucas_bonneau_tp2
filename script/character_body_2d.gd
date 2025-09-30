extends CharacterBody2D


@export var vitesse_marche = 500.0
@export var vitesse_course = 750.0
@export_range(0, 1) var acceleration = 0.2
@export_range(0, 1) var deceleration = 0.2
@export var tomber = 20

@export var force_saut = -600
@export_range(0, 1) var deceleration_saut_relacher = 0.5

@onready var sprite = $perso_principal
 
#en train d'attaquer
var combo_step = 0
var is_attacking = false
var attack_queued = false
var combo_timer = 0.0
var combo_max_delay = 0.4



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
	
	if direction != 0:
		sprite.flip_h = (direction == -1)
	
	if direction:
		velocity.x = move_toward(velocity.x ,direction * vitesse, vitesse * acceleration )
	else:
		velocity.x = move_toward(velocity.x, 0, vitesse_marche * deceleration)
	update_animation(direction)
	move_and_slide()
	
	
func update_animation(direction):
	# Gestion de l'appui sur la touche d'attaque
	if Input.is_action_just_pressed("katana"):
		if is_attacking:
			attack_queued = true  # Enregistre l'intention de combo
		elif combo_step == 0:
			start_attack(1)

	# Si une attaque est en cours
	if is_attacking:
		if not sprite.is_playing():
			if attack_queued and combo_step == 1:
				start_attack(2)  # Enchaîne sur la 2e attaque
			else:
				reset_combo()
		return  # Empêche d'autres animations pendant une attaque

	# Animations normales (hors attaque)
	if is_on_floor():
		if direction == 0:
			sprite.play("idle")
		else:
			sprite.play("course")
	else:
		if velocity.y < -tomber:
			sprite.play("saut")  # monte rapidement => saut
		elif velocity.y > tomber:
			sprite.play("tombe")  # descend vraiment => chute
		else:
			sprite.play("saut")

	# Gestion du temps de combo
	if combo_step > 0:
		combo_timer += get_process_delta_time()
		if combo_timer > combo_max_delay:
			reset_combo()

func start_attack(step):
	if is_on_floor():
		combo_step = step
		is_attacking = true
		attack_queued = false
		combo_timer = 0.0
		if step == 1:
			sprite.play("attaque_01")
		elif step == 2:
			sprite.play("attaque_02")

func reset_combo():
	combo_step = 0
	is_attacking = false
	attack_queued = false
	combo_timer = 0.0
	
func parry():
	pass
		
		
		
