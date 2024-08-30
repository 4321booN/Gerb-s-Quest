extends CharacterBody2D

@export var gravity: int = 25
@export var direction: int = -1 #1 = right, -1 = left
@export var speed: int = 70
@export var health: int = 4
@onready var floor_checker: RayCast2D = $FloorChecker
@export var temp: bool
@onready var sides_checker: Area2D = $SidesChecker
@onready var top_checker: Area2D = $TopChecker
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var healthbar: ProgressBar = $ProgressBar
@onready var progress_bar: ProgressBar = $ProgressBar
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var amount: int = rng.randi_range(3,6) #mana amount

func _ready() -> void:
	rng.randomize()
	sprite.flip_h = direction == 1

func _physics_process(_delta: float) -> void:
	if (is_on_wall() or not floor_checker.is_colliding()):
		direction = direction * -1
	progress_bar.value = health
	floor_checker.position.x = (hitbox.shape.size.x)/2 * direction
	sprite.flip_h = direction == 1
	velocity.y += gravity
	velocity.x = speed * direction
	move_and_slide()
	if speed > 0:
		sprite.play("walk")
	elif health > 0:
		sprite.play("idle")
	if health == 0:
		health = -1
		speed = 0
		set_collision_mask_value(1, false)
		Global.add_mana(amount)
		sprite.play("dissolve")
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_TopChecker_body_entered(_body: Node2D):
	if _body.collision_layer == 1:
		_body.bounce()
		health -= 1


func _on_SidesChecker_body_entered(_body: Node2D):
	if _body.collision_layer == 1:
		_body.hurt(position.x)
	elif _body.collision_layer == 32:
		print("hit with magic_missile:")
		prints("my pos:",global_position,", its pos:",_body.global_position)
		health -= 2
		if health == -1:
			health = 0
