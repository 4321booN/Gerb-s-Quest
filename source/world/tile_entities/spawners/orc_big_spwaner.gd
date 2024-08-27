extends Node2D

@onready var orc_big: PackedScene = preload("res://source/entities/monsters/OrcBig.tscn")


func _ready() -> void:
	var inst := orc_big.instantiate()
	get_parent().add_child(inst)
	inst.position.y = position.y
	inst.position.x = position.x
	queue_free()
