extends Control

@onready var grid = $BG/CenterContainer/VBoxContainer/Grid
@onready var manage_btn = $BG/CenterContainer/VBoxContainer/ManageBtn

func _ready():
	# if there's no member, goto member setup page
	if Global.members.is_empty():
		SceneManager.change_scene("res://UI/MemberSetup.tscn")
		return

	render_members()
	manage_btn.pressed.connect(_on_manage_clicked)

func render_members():
	# cleanup current child nodes
	for child in grid.get_children():
		child.queue_free()
	
	for i in range(Global.members.size()):
		var m = Global.members[i]
		var btn = Button.new()
		btn.text = m["name"]
		btn.custom_minimum_size = Vector2(140, 80)
		
		btn.modulate = Color(m["color"]) 
		
		btn.pressed.connect(func(): _on_member_selected(i))
		grid.add_child(btn)

func _on_member_selected(index: int):
	Global.set_active_member(index)
	SceneManager.change_scene("res://Scenes/Hub.tscn")

func _on_manage_clicked():
	SceneManager.change_scene("res://UI/MemberSetup.tscn")
