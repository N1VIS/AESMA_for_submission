extends Control

var is_open = false
@onready var split_shot_button : TextureButton = $NinePatchRect/TabContainer/Weapons/InventorySlot/SplitShotButton
@onready var split_shot_sprite : Sprite2D = $NinePatchRect/GridContainer2/EquipmentSlot/Sprite2D2
#var double_jump_node = preload("res://double_jump_powerup.tscn")
var split_shot_node = preload("res://Scene/Gmmick/split_shot_powerup.tscn")


signal inventory_toggle
signal split_shot_apply
signal split_shot_undo
#
func _ready():
	visible = false
##	var double_jump_instance = double_jump_node.instantiate()
##	var double_jump_signal = double_jump_instance.get_node("/root/double_jump_powerup/DoubleJumpPower")
#	var split_shot_instance = split_shot_node.instantiate()
#	var split_shot_signal = split_shot_instance.get_node("/root/split_shot/SplitShotPowerup")
#	split_shot_signal.update_inventory.connect(self,"on_update_inventory")

func _physics_process(_delta):
	if Input.is_action_just_pressed("toggle_inventory") and is_open == false:
		visible = !visible
		emit_signal("inventory_toggle")
		



func _on_split_shot_button_pressed():
	if split_shot_sprite.visible == false:
		emit_signal("split_shot_apply")
		split_shot_sprite.visible = true
	elif split_shot_sprite.visible == true:
		emit_signal("split_shot_undo")
		split_shot_sprite.visible = false
	
