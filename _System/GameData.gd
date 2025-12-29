extends Node

var game_card_data = [
	{
		"id": "dual_core",
		"title": "双核视界",
		"players": "2 成员",
		"desc": "一个屏幕，两个视野。上下分屏的反应力挑战",
		"scene": "res://Scenes/GameLobby.tscn"
	},
	{
		"id": "memory_echo",
		"title": "记忆回响",
		"players": "2 成员",
		"desc": "异步解谜，当前成员留下线索，帮助下一位上线的成员通关。",
		"scene": "res://Scenes/GameLobby.tscn"
	},
	{
		"id": "garden",
		"title": "共栖庭院",
		"players": "1 成员",
		"desc": "共同维护的数字花园，尊重每个成员的独特审美。",
		"scene": "res://Scenes/GameLobby.tscn"
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
