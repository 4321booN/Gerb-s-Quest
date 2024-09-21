extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_Gem1_body_entered(_body):
	animation_player.play("collect_bounce")
	Global.add_gem("gem")
	Audio.sfx("pickup_gem")
	set_deferred("monitoring", false)


func _on_AnimationPlayer_animation_finished(_anim_name):
	if _anim_name == "collect_bounce":
		queue_free()
