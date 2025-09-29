extends Node2D

@onready var anim : AnimationPlayer = $AnimationPlayer
var explode = false
@export var exploded = false
var lerpFactor = randf_range(0.0002, 0.01)  # 線形補間係数
var addlerp = 0.00002
var speed = 80  # 移動速度
var health = 20
var chase = false #いらんけど付けとく
var knockback = false #いらんけど付けとく
var knockback_dir = Vector2(0,0) #いらんけど付けとく
@export var attack_power = 5



func _physics_process(delta):
	if explode == false:
		anim.play("idle")
		
		var player_char = $"../Player" 
		var playerPosition = player_char.global_position
		
		if lerpFactor < randf_range(0.03, 0.5) :
			lerpFactor += addlerp
			global_position = global_position.lerp(playerPosition, lerpFactor)
		else:
			var direction = (playerPosition - global_position).normalized()
	
			global_position += direction * speed * delta
			speed = speed + 0.8
	
	if health <= 0 or exploded == true:
		exploded = false
		queue_free()
	
	if explode == true:
		anim.play("Explode")
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		explode = true

func _on_area_2d_2_body_entered(body):
	if body.is_in_group("player"):
		body.health -= attack_power
		body.knockback = true
