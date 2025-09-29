extends CharacterBody2D

var chase = false
var attacking = false
var death = false
var dead = false
var awake = false
var powered_up = false
@export var health = 50
@export var speed = 100
@export var attack_power = 40

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var sprite_position : Marker2D = $Marker2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_char

func _physics_process(delta):
	player_char = $"../Player"
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction = (player_char.position - position).normalized()
	# Add the gravity.

		
	if chase == true and !death and !dead and !attacking:
		anim.play("move")
		velocity.x = direction.x * speed
		if player_char.position.x > self.position.x:
			sprite_position.scale.x = 1
		else:
			sprite_position.scale.x = -1
			
	if health <= 0:
		death = true
		collision_mask = 2
		velocity.x = 0
		
	if death == true:
		anim.play("death")
	
	if dead == true:
		anim.play("dead")
		
	if attacking == true:
		velocity.x = 0
		
	if health <= 400:
		powered_up = true
	
			
	move_and_slide()
		
	
		
		


func _on_detection_area_body_entered(body):
	if body.is_in_group("player") and !awake:
		anim.play("awake")
		




func _on_animation_player_animation_finished(anim_name):
	if anim_name == "awake":
		chase = true
		awake = true
	if anim_name == "death":
		dead = true
	if anim_name == "attack1":
		attacking = false
	if anim_name == "attack2":
		attacking = false


func _on_ranged_attack_1_detection_body_entered(body):
	if body.is_in_group("player") and awake:
		anim.play("attack1")
		attacking = true



func _on_melee_attack_1_detection_body_entered(body):
	if body.is_in_group("player") and awake:
		anim.play("attack2")
		attacking = true
