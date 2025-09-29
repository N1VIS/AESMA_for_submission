extends Area2D

@export var speed : int = 600
@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D
@export var bullet_damage : int = 10
@export var bullet_range = 20



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	if bullet_range == 0:
		queue_free()
	bullet_range -= 1
	
#かにかま



func _on_body_entered(body):
	if body.is_in_group("enemy"):
		var tween = get_tree().create_tween()
		tween.tween_property(body, "modulate",Color(80 , 80 , 80), 0.05)
		tween.tween_property(body, "modulate",Color(1 , 1 , 1), 0.1)
		var node_name = body.get_name()
		if node_name == "Boss_Mage" :
			if body.shield == true :
				body.health -= float(bullet_damage) / 2
			else:
				body.health -= bullet_damage
		else :
			body.health -= bullet_damage
		queue_free()
		body.chase = true
#		print(body.health)
	queue_free()


func _on_timer_timeout():
	queue_free()
