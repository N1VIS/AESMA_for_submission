extends Node2D

@export var explosion_damage = 20
@onready var anim : AnimationPlayer = $AnimationPlayer


func _ready():
	anim.play("explosion")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explosion":
		queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		var tween = get_tree().create_tween()
		tween.tween_property(body, "modulate:a",0, 0.1)
		tween.tween_property(body, "modulate:a",1, 0.1)
		body.health -= explosion_damage
		body.chase = true
		body.knockback = true
		if self.global_position.x < body.global_position.x :
			body.knockback_dir.x = 1
		elif self.global_position.x > body.global_position.x :
			body.knockback_dir.x = -1
		else:
			body.knockback_dir.x = 0
			
		if self.global_position.y < body.global_position.y :
			body.knockback_dir.y = 1
		else :
			body.knockback_dir.y = -1
