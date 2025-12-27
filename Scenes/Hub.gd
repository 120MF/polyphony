extends Control

@onready var bg = $BG
@onready var greeting = $SafeArea/VBoxContainer/Header/Greeting
@onready var switch_btn = $SafeArea/VBoxContainer/SwitchBtn

@onready var dual_btn = $SafeArea/VBoxContainer/GameList/BtnDual

func _ready() -> void:
	setup_ui()
	switch_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://Scenes/CheckIn.tscn"))
	dual_btn.pressed.connect(func(): print("Start Dual Core"))

func setup_ui():
	var member = Global.get_current_member()
	if member.is_empty():
		greeting.text = "你好，系统"
	else:
		greeting.text = "你好，" + member["name"]
		var base_color = Color(member["color"])
		bg.color = base_color.darkened(0.7)
