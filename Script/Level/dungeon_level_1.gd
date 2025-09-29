extends Node2D


#var double_jump_scene = preload("res://double_jump_powerup.tscn")
#@onready var inventory : Control = $HUD/Inventory
#var double_jump_item = preload("res://double_jump_powerup.tscn")
#@onready var enemy = $Enemy1
#@onready var hud : CanvasLayer = $HUD
#@onready var player : CharacterBody2D = $Player
#var paused = false
#
func _ready():
	pass
#	var double_jump_node = $DoubleJumpPower
#	double_jump_node.update_inventory.connect(on_update_inventory)

func _process(_delta):
	pass
#	if Input.is_action_just_pressed("pause"):
#		pauseMenu()	
		
	
#func on_update_inventory():
#	inventory.double_jump_icon.visible = true


#func _on_double_jump_power_update_inventory():
#	inventory.double_jump_icon.visible = true


#func _on_enemy_1_died():
#	spawn_double_jump(enemy.position)
	
#func spawn_double_jump(position):
#	var double_jump_scene = double_jump_item.instantiate()
#	var double_jump_spawn_location = enemy.position
#	double_jump_scene.position = double_jump_spawn_location
#	add_child(double_jump_scene)
#	double_jump_scene.update_inventory.connect(on_update_inventory)
	
#func _on_boss_1_died():
#	spawn_double_jump(enemy.position)


#func _on_enemy_3_died():
#	spawn_double_jump(enemy.position)


func _on_gate_1_door_body_entered(body):
	if body.is_in_group("player"):
		$Player/Warp/AnimationPlayer.play("warp_reverse")
		await get_tree().create_timer(0.73).timeout
		get_tree().change_scene_to_file("res://Scene/Level/midnight_joe_stage.tscn")
		
