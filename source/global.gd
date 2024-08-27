extends Node


var max_health: int = 3
var health: int = max_health
var gems: int = 0
var mana: int = 0
var level = 1
var staffpowerup = "none"

func _ready():
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
