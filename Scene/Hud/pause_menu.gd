extends Control

@onready var hud = $".."

func _on_resume_pressed():
	hud.pauseMenu()


func _on_quit_pressed():
	get_tree().quit()
