extends CharacterBody2D

@onready var player: CharacterBody2D = %Gerb


func _ready() -> void:
	await get_tree().create_timer(7).timeout
	queue_free()

func _physics_process(_delta: float) -> void:
	position.x = player.position.x
	position.y = player.position.y
