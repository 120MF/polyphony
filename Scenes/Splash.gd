extends Control

@onready var title = $CenterContainer/VBoxContainer/Title
@onready var enter_btn = $CenterContainer/VBoxContainer/EnterBtn

func _ready() -> void:
	play_intro()
	
	enter_btn.pressed.connect(func(): 
		if Global.members.is_empty():
			SceneManager.change_scene("res://Scenes/MemberSetup.tscn")
		else:
			SceneManager.change_scene("res://Scenes/CheckIn.tscn")
	)


func play_intro():
	var tween = create_tween()
	
	title.modulate.a = 0.0
	title.position.y += 20
	tween.tween_property(title, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(title, "position:y", title.position.y - 20, 1.5)
	
	tween.tween_property(enter_btn, "modulate:a", 1.0, 0.5).set_delay(0.5)
	tween.tween_callback(func(): enter_btn.disabled = false)
