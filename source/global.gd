extends Node


var max_health: int = 3
var health: int = max_health
var gems: int = 99
var mana: int = 99
var level: int = 1
var popup_open: bool = false
var level_pass_multiplier: int = 6
var staffpowerup = "none"
var sheild_cooling_down: bool = false
var magic_missile_cooling_down: bool = false
var heal_cooling_down: bool = false
var sheild_cooldown_time: float = 10.00
var magic_missile_cooldown_time: float = 2.00
var heal_cooldown_time: float = 2.00
var sheild_cost: int = 3
var magic_missile_cost: int = 0
var heal_cost: int = 4


func _ready():
	Audio.muted = false
	if level < 1:
		level = 1
	health = max_health


func _process(_delta: float) -> void:
	if health > max_health:
		health = max_health
	if gems < 0:
		gems = 0
	if mana < 0:
		mana = 0


func add_gem(gem_type):
	if gem_type == "gem":
		gems += 1
	if gem_type == "gem_but_better":
		gems += 3


func add_mana(amount):
	mana += amount


func sheild_cooldown() -> void:
	sheild_cooling_down = true
	await get_tree().create_timer(sheild_cooldown_time).timeout
	sheild_cooling_down = false


func magic_missile_cooldown() -> void:
	magic_missile_cooling_down = true
	await get_tree().create_timer(magic_missile_cooldown_time).timeout
	magic_missile_cooling_down = false


func heal_cooldown() -> void:
	heal_cooling_down = true
	await get_tree().create_timer(heal_cooldown_time).timeout
	heal_cooling_down = false
