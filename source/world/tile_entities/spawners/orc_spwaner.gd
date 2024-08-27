extends Node2D

@onready var orc: PackedScene = preload("res://source/entities/monsters/Orc.tscn")


func _ready() -> void:
	var inst := orc.instantiate()
	get_parent().add_child(inst)
	inst.position.y = position.y
	inst.position.x = position.x
	queue_free()
