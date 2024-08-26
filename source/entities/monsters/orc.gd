extends CharacterBody2D

@export var gravity: int = 25
@export var direction: int = -1 #1 = right, -1 = left
@export var speed: int = 70
@export var detects_cliffs: bool= true
@export var health: int = 2
@onready var floor_checker: RayCast2D = $FloorChecker
@onready var sides_checker: Area2D = $SidesChecker
@onready var top_checker: Area2D = $TopChecker
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var healthbar: ProgressBar = $ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var amount: int #mana amount
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	speed += rng.randi_range(-10,10)
	amount = round(rng.randf_range(2,4))
	if direction == 1:
		sprite.flip_h = true
	floor_checker.position.x = (hitbox.shape.size.x)/2 * direction
	floor_checker.enabled = detects_cliffs

func _physics_process(_delta: float) -> void:
	if is_on_wall() or not floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		direction = direction * -1
		sprite.flip_h = not sprite.flip_h
		floor_checker.position.x = (hitbox.shape.size.x)/2 * direction
	if health == 0:
		top_checker.set_deferred("monitoring", false)
		sides_checker.set_deferred("monitoring", false)
		speed = 0
		animation_player.play("healthbar-0%")
		Global.add_mana(amount)
		sprite.play("dissolve")
		await get_tree().create_timer(1.0).timeout
		queue_free()
	velocity.y += gravity
	velocity.x = speed*direction
	move_and_slide()
	if speed > 0:
		sprite.play("walk")


func _on_TopChecker_body_entered(_body):
	if _body.collision_layer == 1:
		_body.bounce()
		health -= 1
		if health == 1:
			animation_player.play("healthbar-50%")

func _on_SidesChecker_body_entered(_body):
	if _body.collision_layer == 1:
		_body.hurt(position.x)
	elif _body.collision_layer == 32:
		health -= 1
		if health == 1:
			animation_player.play("healthbar-50%")
		health -= 1
