extends CanvasLayer

@onready var sprite: AnimatedSprite2D = $PanelContainer2/VBoxContainer/HBoxContainer/AnimatedSprite2D
@onready var label: Label = $PanelContainer2/VBoxContainer/HBoxContainer2/Label
@onready var label_2: Label = $PanelContainer2/VBoxContainer/HBoxContainer2/Label2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	sprite.play(str(Global.health))
	label.text = str(Global.gems)
	label_2.text = str(Global.mana)
