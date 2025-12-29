extends PanelContainer

@onready var title = %Title
@onready var meta = %Meta
@onready var desc = %Desc

signal card_clicked(data)

var card_data

func _ready() -> void:
	pass

func setup(data: Dictionary):
	title.text = data["title"]
	meta.text = "推荐 " + str(data["players"]) + " 成员游玩"
	desc.text = data["desc"]
	card_data = data

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			card_clicked.emit(card_data)
			
			accept_event()
