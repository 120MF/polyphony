extends Control

@onready var title = %Title
@onready var desc = %Desc
@onready var slot_container = %SlotContainer
@onready var start_btn = %StartBtn
@onready var cancel_btn = %CancelBtn

var current_game_data = {}

var member_selectors: Array[OptionButton] = []


func _ready() -> void:
	cancel_btn.pressed.connect(_on_cancel)
	start_btn.pressed.connect(_on_start)
	
	# fade in
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)

func setup(data):
	current_game_data = data
	title.text = data["title"]
	desc.text = data["desc"]
	
	create_slots(data.get("players", 1)) # default 1
	validate_form()

func create_slots(count: int):
	# cleanup old data
	for child in slot_container.get_children():
		child.queue_free()
	member_selectors.clear()
	
	for i in range(count):
		var hbox = HBoxContainer.new()
		
		var label = Label.new()
		label.text = "Player %d" % (i + 1)
		
		var selector = OptionButton.new()
		selector.size_flags_horizontal = Control.SIZE_EXPAND_FILL # 撑满宽度
		selector.item_selected.connect(_on_selection_changed)
		# fill the queue
		populate_selector(selector)
		
		hbox.add_child(label)
		hbox.add_child(selector)
		slot_container.add_child(hbox)
		
		# save to global variable
		member_selectors.append(selector)

func populate_selector(opt: OptionButton):
	opt.add_item("选择成员...", -1) # default ID=-1
	opt.set_item_disabled(0, true) # disable default item
	
	for i in range(Global.members.size()):
		var m = Global.members[i]
		# add_item(label, id)
		opt.add_item(m["name"], i)
	opt.selected = 0
		
func _on_selection_changed(_index):
	validate_form()

func validate_form():
	var selected_ids = []
	var is_valid = true
	
	for opt in member_selectors:
		var id = opt.get_selected_id()
		if id == -1:
			is_valid = false
			break
		if id in selected_ids:
			is_valid = false
			break
		selected_ids.append(id)
	start_btn.disabled = not is_valid

func _on_start():
	var selected_indices = []
	for opt in member_selectors:
		var idx = opt.get_selected_id()
		if idx == -1:
			start_btn.disabled = true
			return
		selected_indices.append(idx)
	
	# TODO: Global.current_session_players = selected_indices
	
	# delete overlay
	queue_free()
	# SceneManager.change_scene(current_game_data["scene"])
	
func _on_cancel():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)
