extends Control

@onready var list_content = $Margin/VBoxContainer/MemberList/ListContent
@onready var name_input = $Margin/VBoxContainer/AddArea/NameInput
@onready var color_picker = $Margin/VBoxContainer/AddArea/ColorPickerButton
@onready var back_btn = $Margin/VBoxContainer/BackBtn
@onready var add_btn = $Margin/VBoxContainer/AddBtn

func _ready() -> void:
	refresh_list()
	
	add_btn.pressed.connect(_on_add_btn_pressed)
	back_btn.pressed.connect(_on_back_btn_pressed)

func refresh_list():
	for child in list_content.get_children():
		child.queue_free()
	for i in range(Global.members.size()):
		var member = Global.members[i]
		create_list_item(i, member)
		
func create_list_item(index: int, data: Dictionary):
	var item_box = HBoxContainer.new()
	
	var color_rect = ColorRect.new()
	color_rect.custom_minimum_size = Vector2(20, 40)
	color_rect.color = Color(data["color"])
	
	var name_label = Label.new()
	name_label.text = data["name"]
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL # 撑开空间
	
	var del_btn = Button.new()
	del_btn.text = "X"
	del_btn.pressed.connect(func(): _on_delete_pressed(index))
	item_box.add_child(color_rect)
	item_box.add_child(name_label)
	item_box.add_child(del_btn)
	list_content.add_child(item_box)
	
func _on_add_btn_pressed():
	var _name = name_input.text.strip_edges()
	if _name == "":
		return
	
	var color = color_picker.color
	
	Global.add_member(_name, color)
	
	name_input.text = ""
	# random a new color
	color_picker.color = Color(randf(), randf(), randf())
	refresh_list()

func _on_delete_pressed(index: int):
	Global.delete_member(index)
	refresh_list()
	
func _on_back_btn_pressed():
	if Global.members.is_empty():
		return
	print("Hello!")
	SceneManager.change_scene("res://Scenes/CheckIn.tscn")
