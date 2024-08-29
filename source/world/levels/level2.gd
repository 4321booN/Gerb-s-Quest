extends Node2D

func _ready():
	Global.level = 1
	HUD.show()


func play_level_music():
	pass


func _process(_delta):
	play_level_music()
