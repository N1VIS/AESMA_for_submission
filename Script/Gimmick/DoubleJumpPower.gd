extends Area2D

signal update_inventory

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.double_jump = true
		emit_signal("update_inventory")
		queue_free()
