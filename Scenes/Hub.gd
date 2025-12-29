extends Control

@onready var bg = $BG
@onready var greeting = $SafeArea/VBoxContainer/Header/Greeting
@onready var system_btn = $SafeArea/VBoxContainer/SystemBtn
@onready var card_list = %CardList

const LOBBY_SCENE = preload("res://UI/GameLobby.tscn")

func _ready() -> void:
	setup_header()
	setup_carousel()
	system_btn.pressed.connect(func(): SceneManager.change_scene("res://Scenes/SystemSetup.tscn"))

func setup_header():
	var s_name = Global.system_name
	greeting.text = "欢迎, %s 系统" % s_name

func setup_carousel():
	var card_scene = preload("res://UI/Components/GameCard.tscn")
	
	for data in GameData.game_card_data:
		var card = card_scene.instantiate()
		card._ready()
		card.setup(data) 
		card.card_clicked.connect(_on_game_selected)
		card_list.add_child(card)
		

func _on_game_selected(data):
	var lobby = LOBBY_SCENE.instantiate()
	add_child(lobby)
	lobby.setup(data)
