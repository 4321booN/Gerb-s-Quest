extends Node2D

@onready var spikes: AnimatedSprite2D = $Spikes
@onready var damager: Area2D = $Damager


func _ready():
	damager.monitoring = false


func _on_PlayerChecker_body_entered(_body):
	if _body.collision_layer == 1:
		damager.monitoring = true
		await get_tree().create_timer(.1).timeout
		damager.monitoring = false
	spikes.play("up")
	await get_tree().create_timer(2).timeout
	spikes.play("down")


func _on_Damager_body_entered(_body):
		if _body.collision_layer == 1:
			_body.spiked()
