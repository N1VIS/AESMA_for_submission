extends CharacterBody2D

var chase = false
var attacking = false
var bullet = preload("res://Scene/Gmmick/enemy_bullet.tscn")
@export var speed = 100.0
@export var attack_rate = 0.5
@export var attack_power = 50
@export var health = 50
var player_char
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var gun : AnimatedSprite2D = $Sprite2D/Gun
@onready var sprite : Sprite2D = $Sprite2D
@onready var raycast1 : RayCast2D = $Sprite2D/RayCast2D
@onready var raycast2 : RayCast2D = $Sprite2D/RayCast2D2
@onready var raycast3 : RayCast2D = $Sprite2D/RayCast2D3
@onready var attack_range : CollisionShape2D = $AttackRange/CollisionShape2D

var knockback = false
var knockback_wait = 0    #ノックバック間隔要変数　数値はfunc内で指定
var knockback_dir = Vector2()
@export var weight = 30   #ノックバックの吹っ飛び指数



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	if raycast1.is_colliding() and attacking == false:
		var coll = raycast1.get_collider()
		if coll.name == "Player":
			chase = true

			
	
	if raycast2.is_colliding() and attacking == false:
		var coll = raycast2.get_collider()
		if coll.name == "Player":
			chase = true

	
	if raycast3.is_colliding() and attacking == false:
		var coll = raycast3.get_collider()
		if coll.name == "Player":
			chase = true

			
	player_char = $"../Player"
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction = (player_char.position - position).normalized()
	
	if attacking:
		gun.look_at(player_char.position)
		anim.play("idle")
		velocity.x = 0
	
	if chase == true and !attacking:
		anim.play("walk")
		velocity.x = direction.x * speed
		
	if chase == true:
		if player_char.position.x > self.position.x:
			sprite.flip_h = false
			gun.flip_v = false
		else:
			sprite.flip_h = true
			gun.flip_v = true
		anim.play("walk")
		attack_range.disabled = false
	
	
			
	if chase == false:
		anim.play("idle")
			
	if health <= 0:
		queue_free()
		
	if knockback == true and knockback_wait <= 0 :
		velocity.y = -300
		velocity.x = direction.x * speed * -2
		knockback = false
		knockback_wait = 90
	
	knockback = false
	knockback_wait -= 1	

	move_and_slide()


func _on_attack_range_body_entered(body):
	if body.is_in_group("player") and chase == true:
		attacking = true
		chase = false


func _on_attack_range_body_exited(body):
	if body.is_in_group("player"):
		attacking = false
		chase = true
		

func _on_timer_timeout():
	if attacking:
		gun.play("shoot")
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = gun.global_position
		bullet_instance.rotation_degrees = gun.rotation_degrees
		owner.add_child(bullet_instance)

func enemy_knockback():
	if knockback == true and knockback_wait <= 0 :
		if knockback_dir.y < 0:
			velocity.y = 8 * weight * knockback_dir.y
			velocity.x = 10 * weight * knockback_dir.x
		else:
			velocity.y = -0.001  #なんでうまくいくかわからんけどヨシ！
			velocity.x = 10 * weight * knockback_dir.x * 1.5
		
		knockback = false
		knockback_wait = 90   #ノックバック間隔
#		print(move_and_slide() , velocity)
	knockback = false
	knockback_wait -= 1
