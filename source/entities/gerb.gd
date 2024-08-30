extends CharacterBody2D


enum States {AIR=1, FLOOR, LADDER, DEAD, NONE}
var state: int = States.AIR
var is_on_ladder: bool = false
@export var speed: float = 200
@export var jump_force: float = 3.3
@export var gravity: int = 25
@export var stop_speed: float = 0.5
const MAGIC_MISSILE: PackedScene = preload("res://source/entities/spells/MagicMissile.tscn")
const SHEILD_SPELL: PackedScene = preload("res://source/entities/spells/SheildSpell.tscn")
var invincible: bool = false
@onready var sprite: AnimatedSprite2D = $PlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: CollisionShape2D = $CollisionShape2D
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()


func _physics_process(_delta: float) -> void:
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
			elif should_climb_ladder():
				state = States.LADDER
			sprite.play("idle")
			if Input.is_action_pressed("walk_r"):
				sprite.flip_h = false
				velocity.x = lerp(velocity.x,speed,0.3)
			elif Input.is_action_pressed("walk_l"):
				sprite.flip_h = true
				velocity.x = lerp(velocity.x,-speed,0.3)
			else:
				velocity.x = lerp(velocity.x,0.00,stop_speed)
			move_and_fall()
			cast_magic_missile()
			cast_sheild()
			cast_heal()
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
			elif should_climb_ladder():
				state = States.LADDER
			if Input.is_action_pressed("walk_r"):
				sprite.play("walk")
				sprite.flip_h = false
				velocity.x = lerp(velocity.x,speed,0.3)
			elif Input.is_action_pressed("walk_l"):
				sprite.play("walk")
				sprite.flip_h = true
				velocity.x = lerp(velocity.x,-speed,0.3)
			else:
				sprite.play("idle")
				velocity.x = lerp(velocity.x,0.00,stop_speed)
			if Input.is_action_just_pressed("jump"):
				velocity.y = -speed * jump_force
				Input.action_release("jump")
				state = States.AIR
			move_and_fall()
			cast_magic_missile()
			cast_sheild()
			cast_heal()
			#caststaffblast()
		States.LADDER:
			if Input.is_action_pressed("crouch"):
				bounce()
				state = States.AIR
			if not is_on_ladder:
				state = States.AIR
			if Input.is_action_pressed("climb_u") or Input.is_action_pressed("climb_d") or Input.is_action_pressed("walk_l") or Input.is_action_pressed("walk_r"):
				sprite.play("climb")
			else:
				sprite.stop()
			if Input.is_action_pressed("climb_u"):
				velocity.y = -speed
			elif Input.is_action_pressed("climb_d"):
				velocity.y = speed
			if Input.is_action_pressed("walk_r"):
				sprite.flip_h = false
				velocity.x = lerp(velocity.x,speed,0.35)
			elif Input.is_action_pressed("walk_l"):
				sprite.flip_h = true
				velocity.x = lerp(velocity.x,-speed,0.35)
			else:
				velocity.x = lerp(velocity.x,0.00,stop_speed+.05)
				velocity.y = lerp(velocity.y,0.00,stop_speed+.05)
			move_and_slide()
			cast_sheild()
		States.DEAD:
			gameover()
			set_modulate(Color(0.65,0.3,0.3,0.5))
		States.NONE:
			pass
	if Global.health == 0:
		state = States.DEAD

#LADDER CHECKS

func should_climb_ladder() -> bool:
	if is_on_ladder and (Input.is_action_pressed("climb_u") or Input.is_action_pressed("climb_d")):
		return true
	else:
		return false


func _on_LadderChecker_body_entered(_body: Node2D) -> void:
	is_on_ladder = true


func _on_LadderChecker_body_exited(_body: Node2D) -> void:
	is_on_ladder = false

#SPELLCASTS


func cast_sheild() -> void:
	if Global.mana >= Global.sheild_cost and Input.is_action_just_pressed("sheild") and not Global.sheild_cooling_down:
		var sheild = SHEILD_SPELL.instantiate()
		get_parent().add_child(sheild)
		sheild.position.y = position.y
		sheild.position.x = position.x
		Global.mana -= rng.randi_range(clampi(Global.sheild_cost - 2, 0, 1000000000000000000),Global.sheild_cost)
		Global.sheild_cooldown()


func cast_magic_missile() -> void:
	if Global.mana >= Global.magic_missile_cost and Input.is_action_just_pressed("magic_missile") and not Global.magic_missile_cooling_down:
		var direction = 1 if sprite.flip_h == false else -1
		var inst = MAGIC_MISSILE.instantiate()
		inst.direction = direction
		inst.position.y = position.y - 2
		inst.position.x = position.x + 33*direction
		get_parent().add_child(inst)
		Global.mana -= rng.randi_range(clampi(Global.magic_missile_cost - 2, 0, 1000000000000000000),Global.magic_missile_cost)
		Global.magic_missile_cooldown()


func cast_heal() -> void:
	if Global.mana >= Global.heal_cost and Input.is_action_pressed("heal") and not Global.heal_cooling_down and Global.health < 3:
		Input.action_release("heal")
		Global.mana -= rng.randi_range(clampi(Global.heal_cost - 2, 0, 1000000000000000000),Global.heal_cost)
		animation_player.play("heal_spell")
		Global.health += 1
		Global.heal_cooldown()

#MOVEMENT

func move_and_fall() -> void:
	velocity.y += gravity #Gravity
	move_and_slide()


func bounce() -> void:
	velocity.y -= jump_force * 200

#DAMAGE

func hurt(enemyposx) -> void:
	if not invincible:
		damage_cooldown()
		Global.health -= 1
		bounce()
		if position.x < enemyposx:
			velocity.x = -150
		elif position.x > enemyposx:
			velocity.x = 150


func _on_Fall_Zone_body_entered(_body) -> void:
	if not invincible:
		damage_cooldown()
		Global.health -= 1
		if Global.health != 0:
			await get_tree().create_timer(1.02).timeout
			Global.gems = 0
			get_tree().reload_current_scene()


func spiked() -> void:
	if not invincible:
		damage_cooldown()
		Global.health -= 1
		Input.action_release("jump")
		Input.action_release("walk_l")
		Input.action_release("walk_r")


func damage_cooldown() -> void:
	invincible = true
	set_modulate(Color(0.65,0.3,0.3,0.5))
	await get_tree().create_timer(.5).timeout
	set_modulate(Color(0.65,0.3,0.3,0.3))
	await get_tree().create_timer(1.8).timeout
	set_modulate(Color(1,1,1,1))
	invincible = false


func gameover() -> void:
	set_modulate(Color(0.65,0.3,0.3,0.5))
	hitbox.disabled = true
	Input.action_release("climb_d")
	Input.action_release("climb_u")
	Input.action_release("jump")
	Input.action_release("walk_l")
	Input.action_release("walk_r")
	Input.action_release("cast_magic_missile")
	Input.action_release("cast_magic_missile")
	Input.action_release("cast_magic_missile")
	Input.action_release("crouch")
	sprite.play("idle")
	await get_tree().create_timer(3.06).timeout
	$PlayerCam.queue_free()
	queue_free()
