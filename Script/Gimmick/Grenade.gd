extends RigidBody2D

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var explosion_area : Area2D = $Area2D
@export var grenade_damege : int = 50
var not_exploded = true

func _physics_process(_delta):
	if not_exploded == true:
		anim.play("default")





#func _on_body_entered(body):
#	if body.is_in_group("enemy"):
#		explosion_area.visible = true
#		Area2D.monitoring = true
#		body.chase = true
#	queue_free()


		
#func _on_area_2d_body_entered(body):
#	if body.is_in_group("enemy"):
#		body.health -= grenade_damege
#		queue_free()
#		body.chase = true
#		print(body.health)
#	queue_free()

#func _on_area_2d_area_entered(body):
#	if body.is_in_group("enemy"):
#		body.health -= grenade_damege
#		queue_free()
#		body.chase = true
#		print(body.health)
#	queue_free()
	
	
#func _on_timer_timeout():
#	not_exploded = false
#	self.freeze = true
#	anim.play("explode")
#	explosion_area.visible = true
#
#	await get_tree().create_timer(0.5).timeout
#	queue_free()





