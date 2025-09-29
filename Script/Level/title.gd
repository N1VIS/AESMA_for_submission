extends Node2D
var start = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	$ParallaxBackground/ParallaxLayer1.motion_offset.x = 10
#	$ParallaxBackground.motion_offset.x = 0.1

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if start == false :
		$ParallaxBackground/ParallaxLayer1.motion_offset.x -= 0.25
		$ParallaxBackground/ParallaxLayer1_b.motion_offset.x -= 0.25
		$ParallaxBackground/ParallaxLayer2.motion_offset.x -= 0.2
		$ParallaxBackground/ParallaxLayer3.motion_offset.x -= 0.1
		$ParallaxBackground/ParallaxLayer4.motion_offset.x -= 0.08
		$ParallaxBackground/ParallaxLayer5.motion_offset.x -= 0.05
	else :
		if $Camera2D.position.y <= 900 :
			$Camera2D.position.y += 10
		elif $Camera2D.position.y > 900 :
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://Scene/Story Scenes/briefing_1.tscn")


func _on_button_pressed():
	start = true
	$StartClick.play()


func _on_area_2d_mouse_entered():
	$StartHover.play()
