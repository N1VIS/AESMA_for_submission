extends Node2D

@export var speed : int = 600
@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D
@export var bullet_damage : int = 10



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	
	
#かにかま






func _on_timer_timeout():
	queue_free()


func _on_bullet_1_body_entered(body):
		if body.is_in_group("enemy"):
			var tween = get_tree().create_tween()
			tween.tween_property(body, "modulate:a",0, 0.1)
			tween.tween_property(body, "modulate:a",1, 0.1)
			body.health -= bullet_damage
			$Bullet1.queue_free()
			body.chase = true
			print(body.health)
		$Bullet1.queue_free()


func _on_bullet_2_body_entered(body):
	if body.is_in_group("enemy"):
		var tween = get_tree().create_tween()
		tween.tween_property(body, "modulate:a",0, 0.1)
		tween.tween_property(body, "modulate:a",1, 0.1)
		body.health -= bullet_damage
		$Bullet2.queue_free()
		body.chase = true
		print(body.health)
	$Bullet3.queue_free()


func _on_bullet_3_body_entered(body):
	if body.is_in_group("enemy"):
		var tween = get_tree().create_tween()
		tween.tween_property(body, "modulate:a",0, 0.1)
		tween.tween_property(body, "modulate:a",1, 0.1)
		body.health -= bullet_damage
		$Bullet3.queue_free()
		body.chase = true
		print(body.health)
	$Bullet3.queue_free()
