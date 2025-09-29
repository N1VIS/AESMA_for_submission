extends CharacterBody2D

var chase = false
@export var attacking = false
@export var speed = 100.0
@export var attack_power = 50
@export var health = 30
var player_char
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var raycast1 : RayCast2D = $Sprite2D/RayCast2D
@onready var raycast2 : RayCast2D = $Sprite2D/RayCast2D2
@onready var raycast3 : RayCast2D = $Sprite2D/RayCast2D3
@onready var sprite : Sprite2D = $Sprite2D

var knockback = false
var knockback_wait = 0    #ノックバック間隔要変数　数値はfunc内で指定
var knockback_dir = Vector2()
@export var weight = 20   #ノックバックの吹っ飛び指数

signal died

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	player_char = $"../Player"
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction = (player_char.position - position).normalized()
	
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
	
	if chase == true and !attacking:
		$AnimationTree["parameters/conditions/idle"] = false
		$AnimationTree["parameters/conditions/is_moving"] = true
#		anim.play("walk")
		if velocity.x == 0 or velocity.y == 0 :
			velocity.x = direction.x * speed
			if player_char.position.x > self.position.x:
				$Sprite2D.scale.x = 1
#				$Sprite2D.flip_h = false
#				$Sprite2D/AttackRadius.scale.x = 1
#				$Sprite2D/AttackRadius/AttackArea.scale.x = 1
#				$Sprite2D/RayCast2D.scale.x = 1
#				$Sprite2D/RayCast2D2.scale.x = 1
#				$Sprite2D/RayCast2D3.scale.x = 1
			else:
				$Sprite2D.scale.x = -1
#				$Sprite2D.flip_h = true
#				$Sprite2D/AttackRadius.scale.x = -1
#				$Sprite2D/AttackRadius/AttackArea.scale.x = -1
#				$Sprite2D/RayCast2D.scale.x = -1
#				$Sprite2D/RayCast2D2.scale.x = -1
#				$Sprite2D/RayCast2D3.scale.x = -1
			
	elif chase == false and !attacking:
		$AnimationTree["parameters/conditions/idle"] = true
		$AnimationTree["parameters/conditions/is_moving"] = false
#		anim.play("idle")
			
	if health <= 0:
		$AnimationTree["parameters/conditions/death"] = true
		await get_tree().create_timer(0.2).timeout
		anim.play("death")
		await get_tree().create_timer(0.9).timeout
		queue_free()
		emit_signal("died")
	else:
		enemy_knockback()
		move_and_slide()


#エネミー用のノックバック処理
func enemy_knockback():
	if knockback == true and knockback_wait <= 0 :
		if knockback_dir.y < 0:
			velocity.y = 7 * weight * knockback_dir.y
			velocity.x = 10 * weight * knockback_dir.x
		else:
			velocity.y = -10  #なんでうまくいくかわからんけどヨシ！
			velocity.x = 10 * weight * knockback_dir.x * 1.5
		
		knockback = false
		knockback_wait = 90   #ノックバック間隔
#		print(move_and_slide() , velocity)
	knockback = false
	knockback_wait -= 1


func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		chase = true
		
func _on_attack_radius_body_entered(body):
	if body.is_in_group("player"):
		attacking = true
		$AnimationTree["parameters/conditions/attack"] = true
#		anim.play("attack")
	

func _on_attack_radius_body_exited(body):
	if body.is_in_group("player") and attacking == false:
		attacking = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		attacking = false
		chase = true
#		$Sprite2D/AttackRadius/AttackArea/CollisionShape2D.disabled
		

