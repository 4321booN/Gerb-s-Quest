extends Node2D

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	Global.level = 1
	HUD.show()


func _process(_delta: float) -> void:
	if bool(rng.randi_range(0,1)) and not Audio.is_music_playing():
		Audio.music("8_bit_adventure")
	else:
		Audio.music("8_bit_nostalgia")
