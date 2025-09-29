extends Node2D

var screen_on = false

func _ready():
	Dialogic.start("missionBriefing2")
	Dialogic.signal_event.connect(turnScreenOn)
	Dialogic.signal_event.connect(display_boss)
	Dialogic.signal_event.connect(backToScreen)
	Dialogic.signal_event.connect(transitionLevel)

	
func _physics_process(_delta):
	pass
	


func turnScreenOn(argument: String):
	if argument == "screen_on":
		var tween = get_tree().create_tween().set_loops().bind_node($Control)
		tween.tween_property($Control, "modulate",Color(1 , 1 , 1), 0.5)
		tween.tween_property($Control, "modulate",Color(1, 1 , 1, 0.5), 1)
		
func display_boss(argument: String):
	if argument == "boss":
		var tween = get_tree().create_tween().bind_node($Control/NinePatchRect/Control/Chiyou)
		tween.tween_property($Control/NinePatchRect/Control/Chiyou, "modulate",Color(0, 0 , 0), 1)
		tween.tween_property($Control/NinePatchRect/Control/Mirage,  "modulate",Color(1, 1 , 1), 1)
		
func backToScreen(argument: String):
	if argument == "back_to_screen":
		var tween = get_tree().create_tween().bind_node($Control/NinePatchRect/Control/Mirage)
		tween.tween_property($Control/NinePatchRect/Control/Mirage,  "modulate",Color(1, 1, 1, 0), 1)
		tween.tween_property($Control/NinePatchRect/Control/Chiyou, "modulate",Color(1, 1, 1), 1)
		
func transitionLevel(argument: String):
	if argument == "transition":
		get_tree().change_scene_to_file("res://Scene/Level/hub_stage.tscn")



#func screen_blinking():
#	if Input.is_action_pressed("shoot") and screen_on == true:
#		var tween2 = get_tree().create_tween().set_loops()
#		tween2.tween_property($Control, "modulate",Color(0 , 0 , 0), 0)
#		tween2.tween_property($Control, "modulate",Color(1 , 1 , 1), 0.1)
#
