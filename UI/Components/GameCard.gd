extends PanelContainer

@onready var title = %Title
@onready var meta = %Meta
@onready var desc = %Desc

func _ready() -> void:
	pass

func setup(data: Dictionary):
	title.text = data["title"]
	meta.text = data["players"]
	desc.text = data["desc"]
