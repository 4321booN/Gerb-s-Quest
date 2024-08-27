extends CharacterBody2D

@export var speed: int = 800
@export var direction: int = -1
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	velocity.x = speed * direction
	sprite.flip_h = direction == 1
	await get_tree().create_timer(4.0).timeout
	queue_free()


func _physics_process(_delta: float) -> void:
	rotate(.3*direction)
	move_and_slide()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("collided")
	queue_free()
