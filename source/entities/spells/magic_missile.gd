extends CharacterBody2D

@export var speed: int = 800
@export var direction: int = -1


func _ready() -> void:
	velocity.x = speed * direction
	await get_tree().create_timer(4.0).timeout
	queue_free()


func _physics_process(_delta: float) -> void:
	if is_on_wall():
		await get_tree().create_timer(0.01).timeout
		queue_free()
	move_and_slide()
