extends Area2D



func _on_body_entered(body):
	if body.is_in_group("player"):
		body.ammo = body.max_ammo
		body.health = body.max_health
		
		
