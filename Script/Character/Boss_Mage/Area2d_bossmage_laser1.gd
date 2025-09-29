extends Area2D

@export var attack_power = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.health -= attack_power
		body.knockback = true
#		print(body.health)
#		print("hit")
