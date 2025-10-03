extends CharacterBody2D

class_name boss

const vitesse = 10 
var suit_joueur: bool

var vie = 150
var vie_max = 150
var vie_min = 0 

var mort: bool = false
var taking_damage: bool = false
var damage_to_deal = 20
var is_dealing_damage: bool = false

var direction: Vector2
const gravite = 900
var kockback_force = 200
var is_roaming: bool = true

func _process(delta):
	if !is_on_floor():
		velocity.y += gravite * delta
		velocity.x = 0
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !mort:
		if !suit_joueur:
			velocity += direction * vitesse * delta
		suit_joueur = true
	elif mort:
		velocity.x = 0
		
func handle_animation():
	var sprite = $AnimatedSprite2D
	if !mort and !taking_damage and is_dealing_damage:
		sprite.play("marche")
		if direction.x == -1:
			sprite.flip_h = true
		elif direction.x == 1: 
			sprite.flip_h = false


func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = [1.5,2.0,2.5].pick_random()
	if !suit_joueur:
		direction = [Vector2.RIGHT, Vector2.LEFT].pick_random()
		velocity.x = 0
