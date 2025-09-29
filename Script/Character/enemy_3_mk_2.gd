extends CharacterBody2D



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var chase = false
var shootable = false
@export var shooting = false
#var melee = false
var cooldown = 100
@export var speed = 100.0
@export var attack_power = 50
@export var health = 50
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var raycast1 : RayCast2D = $Sprite2D/RayCast/RayCast2D
@onready var raycast2 : RayCast2D = $Sprite2D/RayCast/RayCast2D2
@onready var raycast3 : RayCast2D = $Sprite2D/RayCast/RayCast2D3
@onready var raycast4 : RayCast2D = $Sprite2D/RayCast/RayCast2D4
@onready var sprite : Sprite2D = $Sprite2D
@onready var shoot_range : Area2D = $Sprite2D/ShootRadius
#@onready var melee_range : Area2D = $MeleeArea
#@onready var state_machine = $AnimationTree.get("parameters/playback")

var knockback = false
var knockback_wait = 0    #ノックバック間隔要変数　数値はfunc内で指定
var knockback_dir = Vector2()
@export var weight = 30   #ノックバックの吹っ飛び指数


signal died

func _ready():
	pass

func _physics_process(_delta):
	var player_char = $"../Player"
	var direction = (player_char.position - position).normalized()
	
	if not is_on_floor():
		velocity.y += gravity * _delta
	
	if cooldown < 100 :
		cooldown += 1
	
	if raycast1.is_colliding() and raycast1.get_collider().name == "Player" :
#		print("p")
		chase = true
		
	if raycast2.is_colliding() and raycast2.get_collider().name == "Player" :
#		print("p")
		chase = true
		
	if raycast3.is_colliding() and raycast3.get_collider().name == "Player" :
#		print("p")
		chase = true
		
	if raycast4.is_colliding() and raycast4.get_collider().name == "Player" :
#		print("p")
		chase = true
		
	if chase == true and shootable == false and health > 0 :
		if player_char.position.x > self.position.x:
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1
		velocity.x = direction.x * speed
		_walk()
	elif chase == true and shootable == true :
		if cooldown == 100 :
			shooting = true
			$AnimationTree["parameters/conditions/shoot"] = true
			cooldown = 0
	
	if chase == false or shootable == true or shooting == true :
		_idle()
		velocity.x = 0
	
	if health <= 0:
		$AnimationTree["parameters/conditions/dead"] = true
		await get_tree().create_timer(0.2).timeout
		$AnimationPlayer.play("death")
		await get_tree().create_timer(1.1).timeout
		queue_free()
		emit_signal("died")
		
	if knockback == true and knockback_wait <= 0 :
		velocity.y = -300
		velocity.x = direction.x * speed * -2
		knockback = false
		knockback_wait = 90
	
	knockback = false
	knockback_wait -= 1		
	
	move_and_slide()

func _on_shoot_radius_body_entered(body):
	if body.is_in_group("player"): 
		shootable = true
		
func _on_shoot_radius_body_exited(body):
	if body.is_in_group("player"): 
		shootable = false

func _walk():
	$AnimationTree["parameters/conditions/idle"] = false
	$AnimationTree["parameters/conditions/is_moving"] = true

func _idle():
	$AnimationTree["parameters/conditions/idle"] = true
	$AnimationTree["parameters/conditions/is_moving"] = false
	
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


