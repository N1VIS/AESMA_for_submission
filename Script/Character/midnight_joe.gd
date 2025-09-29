extends CharacterBody2D

var cooldown = false
var attack1 = false
var attack2 = false
var attack3 = false
var phase2_attack1 = false
var teleporting = false
var chase = false
var dead = false
@export var max_health = 300
@export var health = 300
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var vfx : AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var aura : CPUParticles2D = $HitArea/CPUParticles2D
@onready var hitArea : CollisionShape2D = $HitArea
@onready var damageArea : Area2D = $DamageAura

var knockback = false #いらんけど付けとく
var knockback_dir = Vector2(0,0) #いらんけど付けとく

var player_char 

func _ready():
	vfx.visible = false
	vfx.is_playing()

func _physics_process(_delta):
	if attack1 == true:
		anim.play("attack1")

	elif attack2 == true:
		anim.play("attack2")
		
	elif attack3 == true:
		anim.play("attack3")
		
	elif phase2_attack1 == true:
		anim.play("phase2_attack1")
		
	elif dead == true:
		anim.play("death")
		
	else:
		anim.play("idle")
		

		
#	if teleporting == true:
#		$CollisionShape2D.disabled = true
#	else:
#		$CollisionShape2D.disabled = false



#func _on_area_2d_body_entered(body):
#	if body.is_in_group("player"):
#		attack1 = true



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack1":
		attack1 = false
		teleporting = true
		anim.stop()
	if anim_name == "attack2":
		attack2 = false
		teleporting = true
		anim.stop()
	if anim_name == "attack3":
		attack3 = false
		teleporting = true
		anim.stop()
		
	if anim_name == "phase2_attack1":
		phase2_attack1 = false
		teleporting = true
		anim.stop()
		
	if anim_name == "death":
		queue_free()
	


func _on_animated_sprite_2d_animation_finished():
	teleporting = false


func _on_attack_1_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.health -= 20
		body.knockback = true



func _on_attack_2_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.health -= 30
		body.knockback = true
		



func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.health -= 10
		body.knockback = true
