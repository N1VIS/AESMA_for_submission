extends Node2D

var visible_value1 : float = -0.13
var visible_value2 : float = -0.13
@onready var player_char : CharacterBody2D = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	var config = ConfigFile.new()
	if config.load("user://boss_stage1.cfg") != OK:
		$Player/Warp/AnimationPlayer.play("RESET")
		var config_boss_stage1 = ConfigFile.new()
		var config_boss_stage2 = ConfigFile.new()
		var config_player = ConfigFile.new()
		config_boss_stage1.set_value("boss_stage1", "joe_defeat", 0)
		config_boss_stage2.set_value("boss_stage2", "mage_defeat", 0)
		config_player.set_value("player", "death_count", 0)
		config_boss_stage1.save("user://boss_stage1.cfg")
		config_boss_stage2.save("user://boss_stage2.cfg")
		config_player.save("user://player.cfg")
		$Gate1_Wall.set_layer_enabled(0,true)
		$Gate1/Sprite2D.visible = false
	else:
		if config.get_value("boss_stage1", "joe_defeat") <= 1 :
			player_char.position = Vector2(312 ,230)
			$Gate1_Wall.set_layer_enabled(0,true)
			$Gate1/Sprite2D.visible = false
		else :
			player_char.position = Vector2(312 ,230)
			$Gate1_Wall.set_layer_enabled(0,false)
			$Gate1/Sprite2D.visible = true
			visible_value2 = 255
#			$Gate2/Level1Door/CollisionShape2D.disabled = true #仮


func _process(_delta):
	$Gate1/Sprite2D.modulate.a = visible_value1
	$Gate2/Sprite2D.modulate.a = visible_value2
	if player_char.is_on_floor() :
		if visible_value1 < 1 :
			visible_value1 += 0.01
		if visible_value2 < 1 :
			visible_value2 += 0.01

func _on_gate_2_door_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scene/Level/dungeon_level_1.tscn")


func _on_gate_1_door_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scene/Level/stage_2.tscn")
