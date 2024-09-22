extends Node

@onready var _sfx: Dictionary = {
	"button":$SFX/Button,
	'damage':$SFX/Damage,
	'enemy_die':$SFX/EnemyDie,
	'enemy_damage':$SFX/EnemyDamage,
	'heal':$SFX/Heal,
	'jump':$SFX/Jump,
	'magic_missile':$SFX/MagicMissile,
	'pickup_gem':$SFX/PickupGem,
	'powerup':$SFX/Powerup,
	'sheild':$SFX/Sheild
}
@onready var _music: Dictionary = {
	'8_bit_adventure':$"Music/8BitAdventure",
	'8_bit_nostalgia':$"Music/8BitNostalgia"
}
var muted: bool = false


func _process(_delta: float) -> void:
	if muted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)


func music(track: String) -> void:
	if _music.has(track):
		_music[track].play()
	else:
		printerr("Could not find track: "+track+" in _music.")


func is_music_playing() -> bool:
	for i in _music:
		if _music[i].playing:
			return true
		else:
			return false
	return false


func sfx(sound: String) -> void:
	if _sfx.has(sound):
		_sfx[sound].play()
	else:
		printerr("Could not find sound: "+sound+" in _sfx.")
