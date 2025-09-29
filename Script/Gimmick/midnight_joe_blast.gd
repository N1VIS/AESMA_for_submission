extends Node2D



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "blast":
		queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.health -= 20
