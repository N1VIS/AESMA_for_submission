extends CharacterBody2D

var mouse_pos = Vector2()
var gun_pos = Vector2()
@export var max_health = 100
@export var max_ammo = 10
@export var max_camp = 5
var health = 100
var ammo = 10
var camp_count = 5
var bullet = preload("res://Scene/Gmmick/bullet.tscn")
var split_shot_bullet = preload("res://Scene/Gmmick/split_shot_bullet.tscn")
var grenade = preload("res://Scene/Gmmick/grenade.tscn")
var explosion = preload("res://Scene/Gmmick/explosion.tscn")
var camp = preload("res://Scene/Gmmick/camp.tscn")
var shootable = true
var resting = false
@export var fireRate = 0.5  # 銃の発射間隔（秒）
var firetimer = 0.0  # 発射タイマー
var is_on_ground = false
var is_crouched = false
var has_double_jumped = false
var has_split_shot = false
var is_rolling = false
var face_right = true
var ball_instance = null
var inventory_open = false
var story_mode = false
var paused = false
@export var speed = 200.0
@export var roll_speed = 400
@export var double_jump = false
@export var jump_velocity = -400.0
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var gun_sprite : AnimatedSprite2D = $Sprite2D/AnimatedSprite2D
@onready var hitbox : CollisionShape2D = $CollisionShape2D
@onready var gun_SFX : AudioStreamPlayer2D = $GunshotSFX
@onready var grenade_shot_SFX : AudioStreamPlayer2D = $GrenadeShotSFX
@onready var grenade_explosion_SFX : AudioStreamPlayer2D = $GrenadeExplosionSFX

var knockback = false
var knockback_wait = 0    #ノックバック間隔要変数　数値はfunc内で指定
var knockback_dir = Vector2()
@export var weight = 20   #ノックバックの吹っ飛び指数

signal update_health
signal update_ammo
signal update_tent

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var config = ConfigFile.new()
	if config.load("user://player.cfg") == OK:
		if config.get_value("player", "death_count") == 1:
			config.set_value("player", "death_count", 2)
			config.save("user://player.cfg")
			Dialogic.start("you_are_dead")
			story_mode = true
			await get_tree().create_timer(0.135).timeout
			story_mode = false

func _physics_process(delta):
	if Engine.time_scale == 0 :
		story_mode = true
		paused = true
	elif Engine.time_scale != 0 and paused == true :
		story_mode = false
		paused = false
	
	if story_mode == false:
		mouse_pos = get_global_mouse_position()
		gun_pos = get_global_mouse_position()
	#	gun_position()
		
		# スプライトの反転
		splite_flip()
	#	if velocity.x == 0 and velocity.y== 0:
	#		if mouse_pos.x >= position.x:
	#			face_right = true
	#
	#		if mouse_pos.x <= position.x:
	#			face_right = false
				
		# Add the gravity.
		
		if not is_on_floor():
			velocity.y += gravity * delta
		
		# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
			is_on_ground = false
			
		if Input.is_action_just_pressed("jump") and !is_on_floor() and double_jump == true and !has_double_jumped:
			velocity.y = jump_velocity
			has_double_jumped = true

		elif Input.is_action_just_released("jump") and !is_on_floor() and velocity.y < 0 :
			velocity.y = 0
			

			

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if Input.is_action_pressed("right") and is_crouched == false:
			velocity.x = direction * speed
			if is_on_floor() and speed != 0:
				anim.play("walk")
			sprite.flip_h = false
			gun_sprite.flip_v = false
			if mouse_pos.x <= position.x:
				gun_pos.x = position.x * 2 - mouse_pos.x
			
		elif Input.is_action_pressed("left") and is_crouched == false:
			velocity.x = direction * speed
			if is_on_floor() and speed != 0:
				anim.play("walk")
			sprite.flip_h = true
			gun_sprite.flip_v = true
			if mouse_pos.x >= position.x:
				gun_pos.x = position.x * 2 - mouse_pos.x
			
		elif is_on_ground and is_crouched == false and is_rolling == false:
			velocity.x = move_toward(velocity.x, 0, speed)
			anim.play("idle")
		
		
		gun_sprite.look_at(gun_pos)

		if shootable:
			if Input.is_action_just_pressed("shoot"):
				shoot()
			if Input.is_action_just_released("throw"):
				throw()
		else:
			firetimer += delta
			if firetimer >= fireRate:
				firetimer = 0.0
				shootable = true
				
		if Input.is_action_just_pressed("set_camp") and camp_count >= 0:
			var camp_instance = camp.instantiate()
			owner.add_child(camp_instance)
			camp_instance.position = $CampPosition.global_position
			camp_count -= 1
			emit_signal("update_tent",camp_count)
			
		if resting and ammo <= 0:
			health += 1
			ammo = max_ammo
				
			#ジャンプアニメーション
		if is_on_floor():
			is_on_ground = true
			has_double_jumped = false
		else:
			is_on_ground = false
			if velocity.y < 0:
				anim.play("jump")
			else:
				anim.play("fall")
				
		if Input.is_action_pressed("crouch") and is_on_floor():
			is_crouched = true
			velocity.x = 0
			anim.play("crouch")
		if Input.is_action_just_released("crouch"):
			is_crouched = false
			
			
	#	if Input.is_action_just_pressed("roll"):
	#		if sprite.flip_h == true:
	#			velocity.x -= roll_speed
	#			anim.play("roll")
	#			is_rolling = true
	#			await get_tree().create_timer(0.3).timeout
	#			is_rolling = false 
	#		elif sprite.flip_h == false:
	#			velocity.x = roll_speed
	#			anim.play("roll")
	#			is_rolling = true
	#			await get_tree().create_timer(0.3).timeout
	#			is_rolling = false 
				
		if health <= 0:
			var config = ConfigFile.new()
			if config.load("user://player.cfg") == OK:
				if config.get_value("player", "death_count") == 0:
					config.set_value("player", "death_count", 1)
					config.save("user://player.cfg")
			else :
				config.set_value("player", "death_count", 1)
				config.save("user://player.cfg")
			$Warp/AnimationPlayer.play("warp_reverse")
			await get_tree().create_timer(0.7).timeout
			get_tree().change_scene_to_file("res://Scene/Level/hub_stage.tscn")
			
	if Input.is_action_just_pressed("teleport"):
		teleport()
		
	if Input.is_action_just_pressed("explode"):
		if ball_instance != null :
			explode()
			grenade_explosion_SFX.play()
		
	elif story_mode == true :
#		pass
		velocity.x = 0
		velocity.y = 0
		anim.play("RESET")
		gun_sprite.play("default")
		
		
	#強引に更新
	emit_signal("update_health", health)
	emit_signal("update_ammo", ammo)
		
	player_knockback()
	move_and_slide()
	
	
# 銃の向きを変えるfunc
func gun_position():
	
	
	if velocity.x > 0 :
		face_right = true
	
		if mouse_pos.x <= position.x:
			gun_pos.x = position.x * 2 - mouse_pos.x
	
	if velocity.x < 0 :
		face_right = false
	
		if mouse_pos.x >= position.x:
			gun_pos.x = position.x * 2 - mouse_pos.x
	
	gun_sprite.look_at(gun_pos)

# スプライトのflip反映用
func splite_flip():
	
	if velocity.x == 0 and !Input.is_action_pressed("right") and !Input.is_action_pressed("left") :
		if mouse_pos.x >= position.x:
			face_right = true

		if mouse_pos.x <= position.x:
			face_right = false
	
	if face_right == true :
		sprite.flip_h = false
		gun_sprite.flip_v = false

	if face_right == false :
		sprite.flip_h = true
		gun_sprite.flip_v = true

# 通常射撃機能
func shoot():
	if has_split_shot == false and inventory_open == false:
		var bullet_instance = bullet.instantiate()
		owner.add_child(bullet_instance)
		bullet_instance.position = gun_sprite.global_position
		bullet_instance.rotation_degrees = gun_sprite.rotation_degrees
		gun_sprite.play("fire1")
		gun_SFX.play()
		shootable = false
	if has_split_shot == true and inventory_open == false:
		var bullet_instance = split_shot_bullet.instantiate()
		owner.add_child(bullet_instance)
		bullet_instance.position = gun_sprite.global_position
		bullet_instance.rotation_degrees = gun_sprite.rotation_degrees
		gun_sprite.play("fire1")
		gun_SFX.play()
		shootable = false


# 通常グレ機能
func throw():
	if ammo > 0:
		if ball_instance != null :
			ball_instance.queue_free()
		var grenade_instance = grenade.instantiate()
		ball_instance = grenade_instance
		ball_instance.position = get_global_position()
		owner.add_child(grenade_instance)
#		ammo -= 1
		emit_signal("update_ammo", ammo)
		grenade_instance.global_position = gun_sprite.global_position
		var force = 400
		var impulse = grenade_instance.global_position.direction_to(gun_pos) * force
		grenade_instance.apply_central_impulse(impulse)
		gun_sprite.play("fire2")
		grenade_shot_SFX.play()
		shootable = false
	else :
		gun_sprite.play("fire2_empty")
		
func teleport():
	if is_instance_valid(ball_instance):
		var player_height = 10.5
		ball_instance.queue_free()
		position = ball_instance.global_position - Vector2(0, player_height)
		$Warp/AnimationPlayer.play("teleport")
		$TeleportSFX.play()
		
		
func explode():
	if is_instance_valid(ball_instance):
		var explosion_instance = explosion.instantiate()
		explosion_instance.position = ball_instance.get_global_position()
		owner.add_child(explosion_instance)
		ball_instance.queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy_melee"):
#		var tween = get_tree().create_tween()
#		tween.tween_property(self, "modulate",Color(80 , 80 , 80), 0.05)
#		tween.tween_property(self, "modulate",Color(1 , 1 , 1), 0.1)
		health -= area.attack_power
		$PlayerDmg.play()
		
		emit_signal("update_health", health)
		knockback = true
		if self.global_position.x < area.global_position.x :
			knockback_dir.x = -1
		elif self.global_position.x > area.global_position.x :
			knockback_dir.x = 1
		else:
			knockback_dir.x = 0
		if self.global_position.y < area.global_position.y :
			knockback_dir.y = 1
		else :
			knockback_dir.y = -1
		
			
		
	if area.is_in_group("camp"):
		emit_signal("update_health", health)
		emit_signal("update_ammo", ammo)
	elif area.is_in_group("enemy_projectile"):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate",Color(80 , 80 , 80), 0.05)
		tween.tween_property(self, "modulate",Color(1 , 1 , 1), 0.1)
		health -= area.attack_power
		$PlayerDmg.play()
		emit_signal("update_health", health)
		knockback = true
		if self.global_position.x < area.global_position.x :
			knockback_dir.x = -1
		elif self.global_position.x > area.global_position.x :
			knockback_dir.x = 1
		else:
			knockback_dir.x = 0
		if self.global_position.y < area.global_position.y :
			knockback_dir.y = 1
		else :
			knockback_dir.y = -1
			
	elif area.is_in_group("pit"):
		health = 0
		
		#ボス側で制御するため不要
#	if area.is_in_group("mageboss_laser"):
#		var tween = get_tree().create_tween()
#		tween.tween_property(self, "modulate:a",0, 0.1)
#		tween.tween_property(self, "modulate:a",1, 0.1)
#		health -= area.attack_power
#		emit_signal("update_health", health)
#
#	if area.is_in_group("mageboss_bullet"):
#		var tween = get_tree().create_tween()
#		tween.tween_property(self, "modulate:a",0, 0.1)
#		tween.tween_property(self, "modulate:a",1, 0.1)
#		health -= area.attack_power
#		emit_signal("update_health", health)

func player_knockback():
	if knockback == true and knockback_wait <= 0 :
#		var force = 400
#		knockback_dir.y = 10
#		knockback_dir.x = 0
#		var impulse = knockback_dir * force
#		$PlayerBody.apply_central_impulse(impulse)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate",Color(80 , 80 , 80), 0.05)
		tween.tween_property(self, "modulate",Color(1 , 1 , 1), 0.1)
		if knockback_dir.y < 0:
			velocity.y = 7 * weight * knockback_dir.y
			velocity.x = 10 * weight * knockback_dir.x
		else:
			velocity.y = -100  #なんでうまくいくかわからんけどヨシ！
			velocity.x = 10 * weight * knockback_dir.x * 2
		
		$Area2D/CollisionShape2D.disabled = true
		knockback = false
		knockback_wait = 40   #ノックバック間隔
#		print(move_and_slide() , velocity
	
	if knockback_wait <= 20 : #ここの数値をいじれば無敵時間が変わる
		$Area2D/CollisionShape2D.disabled = false
		
	knockback = false
	knockback_wait -= 1


#[F5]でシーンリロードdasdwadwadsadwda
#func _input(event):
#	if event.is_action_pressed("reload_scene"):
#		get_tree().reload_current_scene()
#
#	if event.is_action_pressed("reset_boss_progress1"):
#		var config = ConfigFile.new()
#		if config.load("user://boss_stage1.cfg") == OK:
#			if config.get_value("boss_stage1", "joe_defeat") == 1:
#				config.set_value("boss_stage1", "joe_defeat", 0)
#				config.save("user://boss_stage1.cfg")
#				print("boss1_reset")
#
#	if event.is_action_pressed("reset_boss_progress2"):
#		var config = ConfigFile.new()
#		if config.load("user://boss_stage2.cfg") == OK:
#			if config.get_value("boss_stage2", "mage_defeat") == 1:
#				config.set_value("boss_stage2", "mage_defeat", 0)
#				config.save("user://boss_stage2.cfg")
#				print("boss2_reset")

func go_to_hub():
#	$Warp.warped = false
	$Warp/AnimationPlayer.play("warp_reverse")
	await get_tree().create_timer(0.73).timeout
	get_tree().change_scene_to_file("res://Scene/Level/hub_stage.tscn")

func story_off1(argument : String):
	if argument == "battleStart":
		story_mode = false
