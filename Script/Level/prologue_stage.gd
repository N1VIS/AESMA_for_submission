extends Node2D
var plus = 0.01
var countdown = 1
@onready var particles1 : GPUParticles2D = $GPUParticles2D_1
@onready var particles2 : GPUParticles2D = $GPUParticles2D_2

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.start("missionBriefing1")
	Dialogic.signal_event.connect(transitionToLevel1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	pass
	
	
	if particles2.emitting == true :
		if particles2.process_material.scale_min < 200 :
			particles2.process_material.scale_min = particles2.process_material.scale_min + plus
			plus = plus * 1.02
		else :
			particles2.process_material.lifetime_randomness = 0
			countdown = countdown + 1
			if countdown == 60 :
				get_tree().change_scene_to_file("res://Scene/Level/hub_stage.tscn")
	
	
func transitionToLevel1(argument: String):
	if argument == "to_hub":
		particles1.emitting = false
		particles2.emitting = true
