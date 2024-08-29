extends Area2D

@onready var upgrade_menu: CanvasLayer = $UpgradeMenu
@onready var upgrade_1_button = $UpgradeMenu/Control/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Upgrade1Button
@onready var upgrade_2_button = $UpgradeMenu/Control/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer2/Upgrade2Button
@onready var upgrade_3_button = $UpgradeMenu/Control/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer3/Upgrade3Button


func _on_body_entered(_body: Node2D) -> void:
	if _body.collision_layer == 1 and Global.gems >= Global.level*Global.level_pass_multiplier and Global.mana >= Global.level*(Global.level_pass_multiplier+1):
		upgrade_menu.show()


func _on_upgrade_1_button_pressed():
	Global.magic_missile_cost -= 1
	upgrade_1_button.disabled = true
	upgrade_menu.hide()
	get_tree().change_scene_to_file("res://source/world/levels/Level"+str(Global.level+1)+".tscn")


func _on_upgrade_2_button_pressed():
	Global.sheild_cost -= 1
	upgrade_2_button.disabled = true
	upgrade_menu.hide()
	get_tree().change_scene_to_file("res://source/world/levels/Level"+str(Global.level+1)+".tscn")


func _on_upgrade_3_button_pressed():
	Global.heal_cost -= 1
	upgrade_2_button.disabled = true
	upgrade_menu.hide()
	get_tree().change_scene_to_file("res://source/world/levels/Level"+str(Global.level+1)+".tscn")
