extends Node2D

#@onready var teleport_player_timer : Timer = $TeleportToPlayerTimer
var midnight_joe_alive = true
var midnight_joe_phase2 = false
var powerup_modifier = 1
var story = true
var joe_defeat : int = 0
@onready var midnight_joe : CharacterBody2D = $"Midnight Joe"
@onready var player_char : CharacterBody2D = $Player
@onready var teleport_timer : Timer = $"Teleport Timer"
#@onready var midnight_health_bar : ProgressBar = $"Midnight Joe Health"
@onready var midnight_health_bar : TextureProgressBar = $"Midnight Joe Health2"

var blast = preload("res://Scene/Gmmick/midnight_joe_blast.tscn")

func _ready():
	midnight_health_bar.max_value = midnight_joe.health
	load_game_data()
	if joe_defeat == 0 :
		story_on()
		player_char.story_mode = true
		midnight_health_bar.visible = false
		Dialogic.signal_event.connect(story_off)
		$Gate1.queue_free()
	elif joe_defeat == 1 :
		midnight_health_bar.visible = true
		teleport_timer.start()
		player_char.story_mode = false
		$Gate1.queue_free()
	elif joe_defeat == 2 :
		midnight_joe.queue_free()
		midnight_health_bar.queue_free()
		player_char.story_mode = false

func _physics_process(_delta):
	if midnight_joe == null :
		if joe_defeat <= 1 :
			midnight_health_bar.queue_free()
			player_char.story_mode = true
			story_on2()
			joe_defeat = 2
			save_game_data()
			Dialogic.signal_event.connect(story_off2)
			

	elif midnight_joe.health != null :
		midnight_health_bar.value = midnight_joe.health
		if midnight_joe.health <= 0 :
			midnight_health_bar.value = 0
	
		if midnight_joe_alive == true:
			midnight_health_bar.value = midnight_joe.health
		
		if midnight_joe_alive == true and midnight_joe.health <= 0:
			midnight_joe_alive = false
			teleport_timer.stop()
		
		if midnight_joe.health <= 250:
			midnight_joe_phase2 = true
			midnight_joe.aura.visible = true
			

		
		if midnight_joe_alive == false:
			midnight_joe.dead = true





func teleport_to_player_right():
	if midnight_joe_phase2 == false:
		midnight_joe.vfx.visible = true
		midnight_joe.vfx.play("teleport_out")
		$Teleport.play()
		
		await get_tree().create_timer(0.4).timeout
		midnight_joe.sprite.visible = false
		midnight_joe.hitArea.visible = true
		midnight_joe.damageArea.visible = false
		await get_tree().create_timer(0.4).timeout
		midnight_joe.position = Vector2(player_char.position.x -50, player_char.position.y)
		midnight_joe.vfx.play("teleport_in")
		$Teleport.play()
		await get_tree().create_timer(0.5).timeout
		midnight_joe.sprite.visible = true
		midnight_joe.hitArea.disabled = false
		midnight_joe.damageArea.visible = true		
		midnight_joe.scale.x = 1
		midnight_joe.attack1 = true
		await  get_tree().create_timer(0.4).timeout
		$Attack1.play()
	if midnight_joe_phase2 == true:
		midnight_joe.vfx.visible = true
		midnight_joe.vfx.play("teleport_out")
		$Teleport.play()
		await get_tree().create_timer(0.4 * powerup_modifier).timeout
		midnight_joe.sprite.visible = false
		await get_tree().create_timer(0.4 * powerup_modifier).timeout
		midnight_joe.position = Vector2(player_char.position.x -50, player_char.position.y)
		midnight_joe.vfx.play("teleport_in")
		$Teleport.play()
		await get_tree().create_timer(0.5 * powerup_modifier).timeout
		midnight_joe.sprite.visible = true
		midnight_joe.scale.x = 1
		midnight_joe.attack1 = true
		$Attack1.play()
	
func teleport_to_player_left():
	if midnight_joe_phase2 == false:
		midnight_joe.vfx.visible = true
		midnight_joe.vfx.play("teleport_out")
		$Teleport.play()
		await get_tree().create_timer(0.4).timeout
		midnight_joe.sprite.visible = false
		midnight_joe.hitArea.disabled = true
		midnight_joe.damageArea.visible = false
		await get_tree().create_timer(0.4).timeout
		midnight_joe.position = Vector2(player_char.position.x + 50, player_char.position.y)
		midnight_joe.vfx.play("teleport_in")
		$Teleport.play()
		await get_tree().create_timer(0.5).timeout
		midnight_joe.sprite.visible = true
		midnight_joe.hitArea.disabled = false
		midnight_joe.damageArea.visible = true
		midnight_joe.scale.x = -1
		midnight_joe.attack1 = true
		await  get_tree().create_timer(0.4 * powerup_modifier).timeout
		$Attack1.play()
	if midnight_joe_phase2 == true:
		midnight_joe.vfx.visible = true
		midnight_joe.vfx.play("teleport_out")
		$Teleport.play()
		await get_tree().create_timer(0.4 * powerup_modifier).timeout
		midnight_joe.sprite.visible = false
		await get_tree().create_timer(0.5 * powerup_modifier).timeout
		midnight_joe.position = Vector2(player_char.position.x + 50, player_char.position.y)
		midnight_joe.vfx.play("teleport_in")
		$Teleport.play()
		await get_tree().create_timer(0.4 * powerup_modifier).timeout
		midnight_joe.sprite.visible = true
		midnight_joe.scale.x = -1
		midnight_joe.attack1 = true
		$Attack1.play()
	
	
func slam_attack():
	if midnight_joe_phase2 == false:
		midnight_joe.vfx.visible = true
		midnight_joe.vfx.play("teleport_out")
		$Teleport.play()
		await get_tree().create_timer(0.4).timeout
		midnight_joe.sprite.visible = false
		midnight_joe.hitArea.disabled = true
		midnight_joe.damageArea.visible = false
		await get_tree().create_timer(0.4).timeout
		midnight_joe.position = Vector2(player_char.position.x, player_char.position.y - 70)
		midnight_joe.vfx.play("teleport_in")
		$Teleport.play()
		await get_tree().create_timer(0.7).timeout
		midnight_joe.sprite.visible = true
		midnight_joe.hitArea.disabled = false
		midnight_joe.damageArea.visible = true
		midnight_joe.attack2 = true
		$Swing.play()
		await get_tree().create_timer(0.9).timeout
		midnight_joe.position = Vector2(midnight_joe.position.x, player_char.position.y + 5)
		$Slam.play()
	if midnight_joe_phase2 == true:
		midnight_joe.vfx.visible = true
		midnight_joe.vfx.play("teleport_out")
		$Teleport.play()
		await get_tree().create_timer(0.4 * powerup_modifier).timeout
		midnight_joe.sprite.visible = false
		await get_tree().create_timer(0.4 * powerup_modifier).timeout
		midnight_joe.position = Vector2(player_char.position.x, player_char.position.y - 70)
		midnight_joe.vfx.play("teleport_in")
		$Teleport.play()
		await get_tree().create_timer(0.7).timeout
		midnight_joe.sprite.visible = true
		midnight_joe.attack2 = true
		await get_tree().create_timer(0.9 * powerup_modifier).timeout
		midnight_joe.position = Vector2(midnight_joe.position.x, player_char.position.y + 5)
		$Slam.play()
	
func vertical_blast():
	var blast1 = blast.instantiate()
	var blast2 = blast.instantiate()
	var blast3 = blast.instantiate()
	var blast_position1 = randi_range(-273, -144)
	var blast_position2 = randi_range(-145, -44)
	var blast_position3 = randi_range(38, 238)
	midnight_joe.vfx.visible = true
	midnight_joe.vfx.play("teleport_out")
	$Teleport.play()
	await get_tree().create_timer(0.4).timeout
	midnight_joe.sprite.visible = false
	midnight_joe.hitArea.disabled = true
	midnight_joe.damageArea.visible = false
	await get_tree().create_timer(0.4 * powerup_modifier).timeout
	midnight_joe.position = Vector2(0,44)
	midnight_joe.vfx.play("teleport_in")
	$Teleport.play()
	await get_tree().create_timer(0.7 * powerup_modifier).timeout
	midnight_joe.sprite.visible = true
	midnight_joe.hitArea.disabled = false
	midnight_joe.damageArea.visible = true
	midnight_joe.attack3 = true
	blast1.position = Vector2(blast_position1,-130)
	blast2.position = Vector2(blast_position2,-130)
	blast3.position = Vector2(blast_position3,-130)
	add_child(blast1)
	add_child(blast2)
	add_child(blast3)
	
func phase2_basic_attack():
	midnight_joe.vfx.visible = true
	midnight_joe.vfx.play("teleport_out")
	$Teleport.play()
	await get_tree().create_timer(0.4).timeout
	midnight_joe.sprite.visible = false
	await get_tree().create_timer(0.4).timeout
	midnight_joe.position = Vector2(player_char.position.x -50, player_char.position.y)
	midnight_joe.vfx.play("teleport_in")
	$Teleport.play()
	await get_tree().create_timer(0.5).timeout
	midnight_joe.sprite.visible = true
	midnight_joe.scale.x = 1
	midnight_joe.phase2_attack1 = true
	midnight_joe.vfx.visible = true
	midnight_joe.vfx.play("teleport_out")
	$Teleport.play()
	await get_tree().create_timer(0.4).timeout
	midnight_joe.sprite.visible = false
	await get_tree().create_timer(0.4).timeout
	midnight_joe.position = Vector2(player_char.position.x + 50, player_char.position.y)
	midnight_joe.vfx.play("teleport_in")
	$Teleport.play()
	await get_tree().create_timer(0.5).timeout
	midnight_joe.sprite.visible = true
	midnight_joe.scale.x = -1
	midnight_joe.phase2_attack1 = true


	
func phase2_slam_blast():
	var blast1 = blast.instantiate()
	var blast2 = blast.instantiate()
	var blast3 = blast.instantiate()
	var blast_position1 = randi_range(-273, -144)
	var blast_position2 = randi_range(-145, -44)
	var blast_position3 = randi_range(38, 238)
	midnight_joe.vfx.visible = true
	midnight_joe.vfx.play("teleport_out")
	$Teleport.play()
	await get_tree().create_timer(0.4).timeout
	midnight_joe.sprite.visible = false
	await get_tree().create_timer(0.4).timeout
	midnight_joe.position = Vector2(player_char.position.x, player_char.position.y - 70)
	midnight_joe.vfx.play("teleport_in")
	$Teleport.play()
	await get_tree().create_timer(0.7).timeout
	midnight_joe.sprite.visible = true
	midnight_joe.attack2 = true
	$Swing.play()
	await get_tree().create_timer(0.9).timeout
	midnight_joe.position = Vector2(midnight_joe.position.x, player_char.position.y + 5)
	$Slam.play()
	await get_tree().create_timer(0.2).timeout
	midnight_joe.attack3 = true
	blast1.position = Vector2(blast_position1,-130)
	blast2.position = Vector2(blast_position2,-130)
	blast3.position = Vector2(blast_position3,-130)
	add_child(blast1)
	add_child(blast2)
	add_child(blast3)
	
	



func _on_teleport_timer_timeout():
	var attack_type = randi_range(1,4)
	if attack_type == 1 and midnight_joe_phase2 == false:
		teleport_to_player_right()
	if attack_type == 2 and midnight_joe_phase2 == false:
		teleport_to_player_left()
	if attack_type == 3 and midnight_joe_phase2 == false:
		slam_attack()
	if attack_type == 4 and midnight_joe_phase2 == false:
		vertical_blast()
		
	if attack_type == 1 and midnight_joe_phase2 == true:
		phase2_basic_attack()
	if attack_type == 2 and midnight_joe_phase2 == true:
		phase2_basic_attack()
	if attack_type == 3 and midnight_joe_phase2 == true:
		phase2_slam_blast()
	if attack_type == 4 and midnight_joe_phase2 == true:
		vertical_blast()


func _on_death_chasm_body_entered(body):
	if body.is_in_group("player"):
		body.health = 0
		
func story_on():
#	print("startstory")
	if story == true:
		Dialogic.start("midnightJoeDialogue")
		
func story_off(argument : String):
	if argument == "battleStart":
		joe_defeat = 1
		save_game_data()
		midnight_health_bar.visible = true
		teleport_timer.start()
		player_char.story_mode = false
		
func story_on2():
	Dialogic.start("midnightJoeDialogue2")
		
func story_off2(argument : String):
	if argument == "battleOver":
#		get_tree().change_scene_to_file("res://Scene/Level/briefing_2.tscn")
#		print("tobrief2")
#		$Player.go_to_hub()
#		$Player/Warp.warped = false
#		$Player/Warp/AnimationPlayer.play("warp_reverse")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scene/Story Scenes/briefing_2.tscn")
#		player_char.story_mode = false
		
func save_game_data():
	var config = ConfigFile.new()
	config.set_value("boss_stage1", "joe_defeat", joe_defeat)
	config.save("user://boss_stage1.cfg")


func load_game_data():
	var config = ConfigFile.new()
	if config.load("user://boss_stage1.cfg") == OK:
		joe_defeat = config.get_value("boss_stage1", "joe_defeat")


func _on_gate_1_door_body_entered(body):
	if body.is_in_group("player"):
		$Player.go_to_hub()
