extends Node2D


@onready var anim_tree_bot : AnimationTree = $laser_bot/AnimationTree
@onready var boss : CharacterBody2D = $"Boss_Mage"
@onready var boss_health_bar : TextureProgressBar = $"Boss_Health_Bar"
@onready var player_char : CharacterBody2D = $Player

@onready var laser_bot = $laser_bot
var mage_defeat : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
#	pass # Replace with function body.
	boss_health_bar.max_value = boss.health
#	player_char.double_jump = true
#	print(mage_defeat)
	load_game_data()
	if mage_defeat == 0 :
		player_char.story_mode = true
		player_char.scale.x = -1
		boss_health_bar.visible = false
		story_on1()
		Dialogic.signal_event.connect(story_off1)
		$Gate1.queue_free()
	elif mage_defeat == 1 :
		$Gate1.queue_free()
		player_char.story_mode = false
		player_char.scale.x = 1
		boss_health_bar.visible = true
		await get_tree().create_timer(1.5).timeout
		boss.story = false
	elif mage_defeat == 2 :
		boss.queue_free()
		boss_health_bar.queue_free()
		player_char.story_mode = false
		player_char.scale.x = 1
	
	$AudioStreamPlayer.play(MusicLoop.musicProgress)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	pass
	
	if boss == null :
#		boss_health_bar.value = 0
		if mage_defeat <= 1 :
			player_char.story_mode = true
			boss_health_bar.queue_free()
			story_on2()
			mage_defeat = 2
			save_game_data()
			Dialogic.signal_event.connect(story_off2)
			print("d")
		if laser_bot != null : 
			laser_bot.queue_free()
			
	elif boss.health != null :
		boss_health_bar.value = boss.health
		if boss.health <= 0 :
			boss_health_bar.value = 0
	
		var random_value = randf()
	#	print(random_value)
		
		if $Boss_Mage.laser_fire1 == true :
		
	#		if random_value < 0.5 :
			if $Boss_Mage.laser_right == false :
				if $laser_bot/Laser_bot1/Sprite2D_Flash1.position.x > 0 :
					$laser_bot/Laser_bot1/Sprite2D_Flash1.position.x *= -1
					$laser_bot/Laser_bot2/Sprite2D_Flash2.position.x *= -1
					$laser_bot/Laser_bot3/Sprite2D_Flash3.position.x *= -1
				$laser_bot/Laser_bot1/Sprite2D_Flash1.flip_h = false
				$laser_bot/Laser_bot2/Sprite2D_Flash2.flip_h = false
				$laser_bot/Laser_bot3/Sprite2D_Flash3.flip_h = false
				$laser_bot/Laser_bot1/Sprite2D_Laser1.flip_h = false
				$laser_bot/Laser_bot2/Sprite2D_Laser2.flip_h = false
				$laser_bot/Laser_bot3/Sprite2D_Laser3.flip_h = false
				$Boss_Mage/Sprite2D.flip_h = false
				if $Boss_Mage/CollisionShape2D.position.x > 0 :
					$Boss_Mage/CollisionShape2D.position.x = -$Boss_Mage/CollisionShape2D.position.x
			else :
				if $laser_bot/Laser_bot1/Sprite2D_Flash1.position.x < 0 :
					$laser_bot/Laser_bot1/Sprite2D_Flash1.position.x *= -1
					$laser_bot/Laser_bot2/Sprite2D_Flash2.position.x *= -1
					$laser_bot/Laser_bot3/Sprite2D_Flash3.position.x *= -1
				$laser_bot/Laser_bot1/Sprite2D_Flash1.flip_h = true
				$laser_bot/Laser_bot2/Sprite2D_Flash2.flip_h = true
				$laser_bot/Laser_bot3/Sprite2D_Flash3.flip_h = true
				$laser_bot/Laser_bot1/Sprite2D_Laser1.flip_h = true
				$laser_bot/Laser_bot2/Sprite2D_Laser2.flip_h = true
				$laser_bot/Laser_bot3/Sprite2D_Laser3.flip_h = true
				$Boss_Mage/Sprite2D.flip_h = true
	#			$Boss_Mage.laser_right = true
				if $Boss_Mage/CollisionShape2D.position.x < 0 :
					$Boss_Mage/CollisionShape2D.position.x = -$Boss_Mage/CollisionShape2D.position.x
				
			
		#	anim_tree.parameters.conditions.swing = true
		#	anim_tree["parameters/conditions/swing"] = true
		
			if $Boss_Mage.phase1 == true :
				if random_value < 0.25 or random_value >= 0.75  :
					anim_tree_bot["parameters/conditions/123"] = true
				else :
					anim_tree_bot["parameters/conditions/321"] = true
				
			if $Boss_Mage.phase2 == true :
				if random_value < 0.2 :
					anim_tree_bot["parameters/conditions/123"] = true
				elif random_value < 0.4 :
					anim_tree_bot["parameters/conditions/321"] = true
				elif random_value < 0.6 :
					anim_tree_bot["parameters/conditions/Double1"] = true
				elif random_value < 0.8 :
					anim_tree_bot["parameters/conditions/Double2"] = true
				else :
					anim_tree_bot["parameters/conditions/Double3"] = true
				
				
			$Boss_Mage.laser_fire1 = false
		
		if anim_tree_bot["parameters/conditions/anim_stopped"] == true :
			$Boss_Mage.cast_finished = true
		
	
##[F5]でシーンリロードdasdwadwadsadwda
#func _input(event):
#	if event.is_action_pressed("reload_scene"):
#		get_tree().reload_current_scene()
	
	
	
	
func save_game_data():
	var config = ConfigFile.new()
	config.set_value("boss_stage2", "mage_defeat", mage_defeat)
	config.save("user://boss_stage2.cfg")


func load_game_data():
	var config = ConfigFile.new()
	if config.load("user://boss_stage2.cfg") == OK:
		mage_defeat = config.get_value("boss_stage2", "mage_defeat")
		

func story_on1():
	Dialogic.start("mirageDialogue")

func story_on2():
	Dialogic.start("mirageDialogue1")
		
func story_off1(argument : String):
	if argument == "battleStart":
		mage_defeat = 1
		save_game_data()
		player_char.story_mode = false
		player_char.scale.x *= -1
		boss_health_bar.visible = true
		await get_tree().create_timer(1.5).timeout
		boss.story = false

func story_off2(argument : String):
	if argument == "battleOver2":
#		player_char.story_mode = false
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scene/Story Scenes/briefing_3.tscn")


func _on_gate_1_door_body_entered(body):
	if body.is_in_group("player"):
		$Player.go_to_hub()
