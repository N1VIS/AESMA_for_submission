extends Area2D

signal add_split_shot_inventory

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("add_split_shot_inventory")
		queue_free()
