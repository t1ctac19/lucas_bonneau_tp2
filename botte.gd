extends Area2D

@export var nouvelle_vitesse = 800.0

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if "vitesse_marche" in body:
			body.vitesse_marche = nouvelle_vitesse
		$son_pick_up.play()
		await $son_pick_up.finished
		queue_free()
