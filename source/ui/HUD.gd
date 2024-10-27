extends CanvasLayer

@onready var sprite: AnimatedSprite2D = $PanelContainer0/VBoxContainer/HBoxContainer/AnimatedSprite2D
@onready var label: Label = $PanelContainer0/VBoxContainer/HBoxContainer2/Label
@onready var texture_button: TextureButton = $PanelContainer1/VBoxContainer/TextureButton
@onready var slider: HSlider = $PanelContainer1/VBoxContainer/HSlider
@onready var label_2: Label = $PanelContainer0/VBoxContainer/HBoxContainer2/Label2
@onready var anim_magic_missile: AnimationPlayer = $AnimationPlayer
@onready var anim_sheild: AnimationPlayer = $AnimationPlayer2
@onready var anim_heal: AnimationPlayer = $AnimationPlayer3
@onready var anim_player: AnimationPlayer = $AnimationPlayer4


func _process(_delta: float) -> void:
	Audio.volume = slider.value
	sprite.play(str(Global.health))
	label.text = str(Global.gems)
	label_2.text = str(Global.mana)
	if Global.magic_missile_cooling_down and not anim_magic_missile.is_playing() and not Global.mana == 0:
		anim_magic_missile.play("magic_missile")
	if Global.sheild_cooling_down and not anim_sheild.is_playing() and not Global.mana == 0:
		anim_sheild.play("sheild")
	if Global.heal_cooling_down and not anim_heal.is_playing() and not Global.mana == 0:
		anim_heal.play("heal")
	Audio.muted = texture_button.button_pressed


func _on_h_slider_value_changed(value: float) -> void:
	if value == 0:
		texture_button.set_pressed_no_signal(true)
	else:
		texture_button.set_pressed_no_signal(false)


func _on_texture_button_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		slider.value = 0.5
