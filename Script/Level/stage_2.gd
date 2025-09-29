extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_gate_1_door_body_entered(body):
	if body.is_in_group("player"):
		$Player/Warp/AnimationPlayer.play("warp_reverse")
		await get_tree().create_timer(0.73).timeout
		get_tree().change_scene_to_file("res://Scene/Level/boss_stage_mage.tscn")
