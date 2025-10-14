extends CharacterBody2D
class_name Boss

@onready var son_attaque = $sword_attack

const VITESSE = 300
const GRAVITE = 900

var suit_joueur: bool = false
var direction: Vector2 = Vector2.ZERO

var vie = 150
var vie_max = 150
var vie_min = 0

var mort: bool = false
var taking_damage: bool = false
var damage_to_deal = 20
var is_dealing_damage: bool = false

var kockback_force = 200
var is_roaming: bool = true

var peut_attaquer: bool = true
var temps_recharge_attaque = 2.0
var distance_attaque = 100




func _ready():
	direction = [Vector2.RIGHT, Vector2.LEFT].pick_random()

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += GRAVITE * delta

	var player = get_parent().get_node("personnage_principal")
	var distance = global_position.distance_to(player.global_position)
	
	if distance < 300:
		suit_joueur = true
	else:
		suit_joueur = false

	if suit_joueur:
		attaquer()

	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if mort:
		velocity.x = 0
		return
		
	if suit_joueur:
		var player = get_parent().get_node("personnage_principal")
		direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * VITESSE

	if !suit_joueur:
		velocity.x = direction.x * VITESSE
	else:
		pass

func handle_animation():
	var sprite = $AnimatedSprite2D
	
	if !mort and !taking_damage and !is_dealing_damage and is_roaming:
		sprite.play("marche")

	if !mort and !taking_damage and is_dealing_damage:
		sprite.play("attaque")
		sprite.flip_h = direction.x < 0
	elif !mort and taking_damage and !is_dealing_damage:
		sprite.play("hurt")
		await get_tree().create_timer(0.6).timeout
		taking_damage = false
	elif mort and is_roaming:
		is_roaming = false
		sprite.play("mort")
		await get_tree().create_timer(1.2).timeout
		handle_death()
		
func attaquer():
	if mort or taking_damage:
		return

	var player = get_parent().get_node("personnage_principal")
	var distance = global_position.distance_to(player.global_position)


	if distance <= distance_attaque and peut_attaquer:
		peut_attaquer = false
		is_dealing_damage = true
		$AnimatedSprite2D.play("attaque")
		$AnimatedSprite2D.flip_h = direction.x < 0

		await get_tree().create_timer(0.4).timeout
		if global_position.distance_to(player.global_position) <= distance_attaque:
			if player.has_method("prendre_degats"):
				player.prendre_degats(damage_to_deal)

		is_dealing_damage = false
		await get_tree().create_timer(temps_recharge_attaque).timeout
		peut_attaquer = true

func handle_death():
	queue_free()

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = [1.5, 2.0, 2.5].pick_random()
	if !suit_joueur:
		direction = [Vector2.RIGHT, Vector2.LEFT].pick_random()
		velocity.x = 0
		
		
		

		
		
