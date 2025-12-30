extends Node

var system_name: String = ""

# {
#   "id": "unix_timestamp_random",
#   "name": "Member Name",
#   "color": "html_hex_color", # e.g., "#ff0000"
#   "created_at": 1234567890
# }

var members: Array = []
var current_member_index: int = -1

func get_current_member() -> Dictionary:
	if current_member_index >= 0 and current_member_index < members.size():
		return members[current_member_index]
	return {} # 返回空字典表示无人/Unknown

func set_active_member(index: int):
	current_member_index = index
	print("Active member switched to: ", index)

const SYSTEM_NAME_SAVE_PATH = "user://polyphony_system_name.save"
const MEMBERS_SAVE_PATH = "user://polyphony_members.save"

func _ready():
	load_data()

func add_member(_name: String, color: Color) -> void:
	var new_member = {
		"id": Time.get_unix_time_from_system(),
		"name": _name,
		"color": color.to_html(), # Color to Hex String
		"created_at": Time.get_unix_time_from_system()
	}
	members.append(new_member)
	save_data()

func update_member(index: int, new_name: String, new_color: Color) -> void:
	if index >= 0 and index < members.size():
		members[index]["name"] = new_name
		members[index]["color"] = new_color.to_html()
		save_data()

func delete_member(index: int) -> void:
	if index >= 0 and index < members.size():
		members.remove_at(index)
		save_data()

func save_data():
	var file = FileAccess.open(MEMBERS_SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(members)
		file.store_string(json_string)
	file = FileAccess.open(SYSTEM_NAME_SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(system_name)

func load_data():
	if not FileAccess.file_exists(SYSTEM_NAME_SAVE_PATH) or not FileAccess.file_exists(MEMBERS_SAVE_PATH):
		return # no data
	
	var file = FileAccess.open(MEMBERS_SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			var data = json.get_data()
			if data is Array:
				members = data
	file = FileAccess.open(SYSTEM_NAME_SAVE_PATH, FileAccess.READ)
	if file:
		system_name = file.get_as_text()
