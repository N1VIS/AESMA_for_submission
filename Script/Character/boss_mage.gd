extends CharacterBody2D

#var cooldown = false
#var attack1 = false
#@onready var anim : AnimationPlayer = $AnimationPlayer
#@onready var boss_mage : CharacterBody2D = $"."
#@onready var anim_tree_bot : AnimationTree = $laser_bot/AnimationTree
#var swing_recast = 90
#var movement = false
#var processed = false  # 一度だけ処理フ
#var movable = true
@export var health = 300
@onready var anim_tree : AnimationTree = $AnimationTree

var mage_bullet = preload("res://Scene/Gmmick/mage_bullet.tscn")

var story = true
var _idle_count = 0
var attack_threshold = 6
var laser_fire1 = false

var laser_right = false
var shootable = false
var shield = true

var phase1 = true
var phase2 = false

var start_position = Vector2(311, 34)  # 移動先の目標位置
var laser_right_position = Vector2(434, 34) #Vector2(534, 34)
var laser_left_position = Vector2(182, 34) #Vector2(82, 34)

var direction = (position).normalized()
var cast_finished = false
var random_value = 0
var speed = 4

var chase = false #いらんけど付けとく
var knockback = false #いらんけど付けとく
var knockback_dir = Vector2(0,0) #いらんけど付けとく

#実験用
#var lerpFactor = 0.065  # 線形補間係数
var increasing = true  # 増加中かどうかのフラグ
var mage_bullet_instance_a = null
var mage_bullet_instance_b = null
var mage_bullet_instance_c = null
var mage_bullet_instance_d = null

func _ready():
	pass


func _physics_process(_delta):
#	撮影用
#	if health >= 300 :
#		health -= 280
	
	if _idle_count == 1 :
		shootable = true
		$CollisionShape2D/GPUParticles2D.emitting = true
		shield = true
		_idle_count += 1
	
	if story == false :
	
		if  phase1 == true and shootable == true :
			shoot_phase1()
		
		if phase2 == true and shootable == true :
			shoot_phase2()
		
		if _idle_count == 4 :
			random_value = randf()
			_idle_count += 1
		
		if random_value != 0 and random_value < 0.5 :
			laser_right = false
			laser_left_move()
		elif random_value != 0 and random_value >= 0.5 :
			laser_right = true
			laser_right_move()
		
		if _idle_count > attack_threshold:
			_idle_count = -6
			attack_laser_fire1()
		
		move_and_collide(velocity) #基本はlarpで動かしてるけど、これでY軸のブレを出してる
		
		if cast_finished == true :
			reset_position()
		
		if health <= 150: #仮
			phase2 = true
			phase1 = false
		
		if health <= 0:
			$AnimationTree["parameters/conditions/dead"] = true
			await get_tree().create_timer(0.5).timeout
			$AnimationPlayer.play("dead")
			await get_tree().create_timer(0.7).timeout
			queue_free()
	


func increase_idle_count():
	_idle_count += 1

func attack_laser_fire1():
	anim_tree["parameters/conditions/swing"] = true
	laser_fire1 = true
	$CollisionShape2D/GPUParticles2D.emitting = false
	shield = false

func shoot_phase1():  # 通常射撃機能phase1 if phase1 == true and shootable == true :
	mage_bullet_instance_a = mage_bullet.instantiate()
	mage_bullet_instance_a.position = global_position + Vector2(-43,60)
	owner.add_child(mage_bullet_instance_a)
	mage_bullet_instance_b = mage_bullet.instantiate()
	mage_bullet_instance_b.position = global_position + Vector2(33,60)
	owner.add_child(mage_bullet_instance_b)
	shootable = false

func shoot_phase2():  # 通常射撃機能phase2 if phase2 == true and shootable == true :
	mage_bullet_instance_a = mage_bullet.instantiate()
	mage_bullet_instance_a.position = global_position + Vector2(-43,60)
	owner.add_child(mage_bullet_instance_a)
	mage_bullet_instance_b = mage_bullet.instantiate()
	mage_bullet_instance_b.position = global_position + Vector2(33,60)
	owner.add_child(mage_bullet_instance_b)
	mage_bullet_instance_c = mage_bullet.instantiate()
	mage_bullet_instance_c.position = global_position + Vector2(-30,90)
	owner.add_child(mage_bullet_instance_c)
	mage_bullet_instance_d = mage_bullet.instantiate()
	mage_bullet_instance_d.position = global_position + Vector2(20,90)
	owner.add_child(mage_bullet_instance_d)
	shootable = false 

func laser_left_move():
	$Sprite2D.flip_h = true
	if $CollisionShape2D.position.x < 0 :
		$CollisionShape2D.position.x = -$CollisionShape2D.position.x
	direction = (laser_left_position - position).normalized()
	global_position = global_position.lerp(laser_left_position, 0.065)
	
	if position.distance_to(laser_left_position) <= speed:
		velocity.y = 0
		position = laser_left_position
		$Sprite2D.flip_h = false
		if $CollisionShape2D.position.x > 0 :
			$CollisionShape2D.position.x = -$CollisionShape2D.position.x
		direction.x = 0
		random_value = 0
	else :
		if increasing:
			velocity.y -= 0.01
			if velocity.y < -0.1:
				increasing = false
		else:
			velocity.y += 0.01
			if velocity.y > 0.1:
				velocity.y = 0
				increasing = true

func laser_right_move():
	$Sprite2D.flip_h = false
	if $CollisionShape2D.position.x > 0 :
		$CollisionShape2D.position.x = -$CollisionShape2D.position.x
	direction = (laser_right_position - position).normalized()
	global_position = global_position.lerp(laser_right_position, 0.065)
	
	if position.distance_to(laser_right_position) <= speed:
		velocity.y = 0
		position = laser_right_position
		$Sprite2D.flip_h = true
		if $CollisionShape2D.position.x < 0 :
			$CollisionShape2D.position.x = -$CollisionShape2D.position.x
		direction.x = 0
		random_value = 0
	
	else :
		if increasing:
			velocity.y -= 0.01
			if velocity.y < -0.1:
				increasing = false
		else:
			velocity.y += 0.01
			if velocity.y > 0.1:
				velocity.y = 0
				increasing = true

func reset_position():
	if laser_right == false :
		$Sprite2D.flip_h = false
		if $CollisionShape2D.position.x > 0 :
			$CollisionShape2D.position.x = -$CollisionShape2D.position.x
		direction = (start_position - position).normalized()
		global_position = global_position.lerp(start_position, 0.04)
	else :
		$Sprite2D.flip_h = true
		if $CollisionShape2D.position.x < 0 :
			$CollisionShape2D.position.x = -$CollisionShape2D.position.x
		direction = (start_position - position).normalized()
		global_position = global_position.lerp(start_position, 0.04)
		
	if position.distance_to(start_position) <= speed:
			velocity.y = 0
			position = start_position
			direction.x = 0
			cast_finished = false
	else :
		if increasing:
			velocity.y -= 0.01
			if velocity.y < -0.1:
				increasing = false
		else:
			velocity.y += 0.01
			if velocity.y > 0.1:
				velocity.y = 0
				increasing = true

func _exit_tree():
	# ノードがツリーから取り除かれるときに行いたい処理をここに書く
#	print("Node is exiting the tree")
	if mage_bullet_instance_a != null :
		mage_bullet_instance_a.queue_free()
	if mage_bullet_instance_b != null :
		mage_bullet_instance_b.queue_free()
	if mage_bullet_instance_c != null :
		mage_bullet_instance_c.queue_free()
	if mage_bullet_instance_d != null :
		mage_bullet_instance_d.queue_free()
	
	
