extends Area2D

@export var attack_power = 20
@export var speed : int = 600
@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	
	
#かにかま





func _on_timer_timeout():
	queue_free()


func _on_body_entered(_body):
	queue_free()
