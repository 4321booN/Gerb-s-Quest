extends Node2D

@onready var spiketrap: PackedScene = preload("res://source/world/tile_entities/Spiketrap.tscn")


func _ready() -> void:
	var inst := spiketrap.instantiate()
	get_parent().add_child(inst)
	inst.position.y = position.y
	inst.position.x = position.x
	queue_free()
