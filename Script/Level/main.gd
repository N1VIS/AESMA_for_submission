extends Node2D

#var double_jump_scene = preload("res://double_jump_powerup.tscn")
@onready var inventory : Control = $HUD/Inventory
var double_jump_item = preload("res://Scene/Gmmick/double_jump_powerup.tscn")
var split_shot_item = preload("res://Scene/Gmmick/split_shot_powerup.tscn")
@onready var player = $Player
@onready var enemy = $Enemy1
#
#func _ready():
#	var double_jump_node = $DoubleJumpPower
#	double_jump_node.update_inventory.connect(on_update_inventory)
	
	
#func spawn_double_jump(position):
#	var double_jump_scene = double_jump_item.instantiate()
#	var double_jump_spawn_location = enemy.position
#	double_jump_scene.position = double_jump_spawn_location
#	add_child(double_jump_scene)
#	double_jump_scene.update_inventory.connect(on_update_inventory)

func _on_enemy_1_died():
	spawn_split_shot(enemy.position)
	
func spawn_split_shot(position):
	var split_shot_scene = split_shot_item.instantiate()
	var split_shot_spawn_location = enemy.position
	split_shot_scene.position = split_shot_spawn_location
	add_child(split_shot_scene)
	split_shot_scene.add_split_shot_inventory.connect(on_update_inventory_split_shot)
	
func on_update_inventory_split_shot():
	inventory.split_shot_button.visible = true
	


func _on_inventory_split_shot_apply():
	player.has_split_shot = true


func _on_inventory_split_shot_undo():
	player.has_split_shot = false

func _on_inventory_inventory_toggle():
	if inventory.visible == true:
		player.inventory_open = true
	elif inventory.visible == false:
		player.inventory_open = false

#[F5]でシーンリロード
func _input(event):
	if event.is_action_pressed("reload_scene"):
		get_tree().reload_current_scene()
