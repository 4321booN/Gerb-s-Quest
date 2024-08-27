extends Node2D

@onready var gem: PackedScene = preload("res://source/entities/features/GemButBetter.tscn")


func _ready() -> void:
	var inst := gem.instantiate()
	get_parent().add_child(inst)
	inst.position.y = position.y
	inst.position.x = position.x
	queue_free()
