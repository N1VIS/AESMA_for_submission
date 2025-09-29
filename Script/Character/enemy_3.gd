extends CharacterBody2D

var chase = false
var shooting = false
var melee = false
var cooldown = false
@export var speed = 100.0
@export var attack_power = 50
@export var health = 50
var player_char
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var raycast1 : RayCast2D = $Sprite/RayCast2D
@onready var raycast2 : RayCast2D = $Sprite/RayCast2D2
@onready var raycast3 : RayCast2D = $Sprite/RayCast2D3
@onready var sprite : Sprite2D = $Sprite
@onready var shoot_range : Area2D = $ShootRadius
@onready var melee_range : Area2D = $MeleeArea
@onready var state_machine = $AnimationTree.get("parameters/playback")

signal died

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	player_char = $"../Player"
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction = (player_char.position - position).normalized()
	
	if raycast1.is_colliding() and shooting == false:
		var coll = raycast1.get_collider()
		if coll.name == "Player":
			chase = true
	
	if chase == true and !shooting:
		state_machine.travel("walk")
		velocity.x = direction.x * speed
		if player_char.position.x > self.position.x:
			sprite.scale.x = 1
			shoot_range.scale.x = 1
#			melee_range.scale.x = 1
		else:
			sprite.scale.x = -1
			shoot_range.scale.x = -1
#			melee_range.scale.x = -1
#
			
	if shooting == true and player_char.position.x > self.position.x:
		state_machine.travel("attack1")
		velocity.x = 0
	if shooting == true and player_char.position.x < self.position.x:
		state_machine.travel("attack1")
		velocity.x = 0
		
#	if melee == true and shooting ==false and player_char.position.x > self.position.x:
#		anim.play("attack2")
#		velocity.x = 0
#	if melee == true and shooting ==false and player_char.position.x < self.position.x:
#		anim.play("attack2")
#		velocity.x = 0

			
	elif chase == false and !shooting and !melee:
		state_machine.travel("idle")
			
	if health <= 0:
		queue_free()
		emit_signal("died")


	move_and_slide()

func _on_shoot_radius_body_entered(body):
	if body.is_in_group("player"): 
		shooting = true
		

#func _on_shoot_radius_body_exited(body):
#	if body.is_in_group("player"):
#		shooting = false



		
		


#func _on_animation_player_animation_finished(anim_name):
#	if anim_name == "attack1":
#		shooting = false
#		$ShootRadius/CollisionShape2D.disabled = true
#		$MeleeArea/MeleeHitBox.disabled = false
#		await get_tree().create_timer(0.6).timeout
#		$ShootRadius/CollisionShape2D.disabled = false
#		$MeleeArea/MeleeHitBox.disabled = true
#		melee = false







#func _on_melee_area_body_entered(body):
#	if body.is_in_group("player"):
#		melee = true
#
#
#func _on_melee_area_body_exited(body):
#	if body.is_in_group("player"):
#		melee = false
