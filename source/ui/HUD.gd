extends CanvasLayer

@onready var sprite: AnimatedSprite2D = $PanelContainer2/VBoxContainer/HBoxContainer/AnimatedSprite2D
@onready var label: Label = $PanelContainer2/VBoxContainer/HBoxContainer2/Label
@onready var label_2: Label = $PanelContainer2/VBoxContainer/HBoxContainer2/Label2
@onready var anim_magic_missile: AnimationPlayer = $AnimationPlayer
@onready var anim_sheild: AnimationPlayer = $AnimationPlayer2
@onready var anim_heal: AnimationPlayer = $AnimationPlayer3
@onready var anim_player: AnimationPlayer = $AnimationPlayer4


func _process(_delta: float) -> void:
	sprite.play(str(Global.health))
	label.text = str(Global.gems)
	label_2.text = str(Global.mana)
	if Global.magic_missile_cooling_down and not anim_magic_missile.is_playing() and not Global.mana == 0:
		anim_magic_missile.play("magic_missile")
	if Global.sheild_cooling_down and not anim_sheild.is_playing() and not Global.mana == 0:
		anim_sheild.play("sheild")
	if Global.heal_cooling_down and not anim_heal.is_playing() and not Global.mana == 0:
		anim_heal.play("heal")
