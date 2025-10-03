class_name MyHurtBox
extends Area2D


func _ready() -> void:
	self.area_entered.connect(_on_area_entered)
	pass
	
func _on_area_entered(area: Area2D) -> void:
	if area is MyHitBox:
		var hitbox = area as MyHitBox
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
	pass
