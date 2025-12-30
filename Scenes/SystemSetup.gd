extends Control

@onready var list_content = $Margin/Panel/PanelMargin/VBoxContainer/MemberList/ListContent
@onready var system_name_input = %SystemNameInput
@onready var member_name_input = %MemberNameInput
@onready var color_picker = $Margin/Panel/PanelMargin/VBoxContainer/AddArea/ColorPickerButton
@onready var finish_btn = $Margin/Panel/PanelMargin/VBoxContainer/FinishBtn
@onready var add_btn = $Margin/Panel/PanelMargin/VBoxContainer/AddBtn

var BASE_STYLE: StyleBoxFlat = preload("res://UI/CommonStyleBoxes/DefaultPanel/glassmorphism_default_panel_alpha_40.tres")

func _ready() -> void:
	color_picker.color = Color(randf(), randf(), randf())
	refresh_list()
	system_name_input.text = Global.system_name
	
	add_btn.pressed.connect(_on_add_btn_pressed)
	finish_btn.pressed.connect(_on_finish_btn_pressed)

func refresh_list():
	for child in list_content.get_children():
		child.queue_free()
	for i in range(Global.members.size()):
		var member = Global.members[i]
		create_list_item(i, member)
	if Global.members.is_empty():
		finish_btn.disabled = true
	else:
		finish_btn.disabled = false

func create_list_item(index: int, data: Dictionary):
	var card = PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size.y = 100
	
	var style = BASE_STYLE.duplicate()
	var base_color = Color(data["color"])
	
	style.bg_color = base_color.lightened(0.3)
	style.bg_color.a = 0.4
	card.add_theme_stylebox_override("panel" ,style)
	
	var item_box = HBoxContainer.new()
	item_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_box.custom_minimum_size.y = 100
	
	var side_width = 90.0
	var left_wrapper = CenterContainer.new()
	left_wrapper.custom_minimum_size.x = side_width
	
	var name_label = Label.new()
	name_label.text = data["name"]

	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER 
	
	# 4. 右侧：删除按钮 (Button)
	var del_btn = Button.new()
	del_btn.flat = true
	del_btn.text = "X" # 或者用 "Remove"
	# 稍微把按钮做方一点
	del_btn.custom_minimum_size = Vector2(side_width, side_width)
	del_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	del_btn.modulate = Color(0.6, 0.6, 0.6) 
	
	del_btn.pressed.connect(func(): _on_delete_pressed(index))
	
	# 5. 组装
	item_box.add_child(left_wrapper)
	item_box.add_child(name_label)
	item_box.add_child(del_btn)
	
	card.add_child(item_box)
	
	# 6. 添加到列表容器
	list_content.add_child(card)
	
	
func _on_add_btn_pressed():
	var _name = member_name_input.text.strip_edges()
	if _name == "":
		return
	
	var color = color_picker.color
	
	Global.add_member(_name, color)
	
	member_name_input.text = ""
	# random a new color
	color_picker.color = Color(randf(), randf(), randf())
	refresh_list()

func _on_delete_pressed(index: int):
	Global.delete_member(index)
	refresh_list()
	
func _on_finish_btn_pressed():
	Global.system_name = system_name_input.text.strip_edges()
	SceneManager.change_scene("res://Scenes/Hub.tscn")
