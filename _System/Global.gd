extends Node

# {
#   "id": "uuid_string", 
#   "name": "Member Name",
#   "color_hex": "#ff0000"
# }

var members: Array = []
var current_fronters: Array = []

# 存档路径
const SAVE_PATH = "user://system_data.json"

func _ready():
	load_data()
	if members.is_empty():
		add_member("Guest", Color.WHITE)

func add_member(name: String, color: Color):
	var new_member = {
		"id": str(Time.get_unix_time_from_system()),
		"name": name,
		"color_hex": color.to_html() # into string
	}
	members.append(new_member)
	save_data()
	return new_member

func update_member(index: int, new_name: String, new_color: Color):
	if index >= 0 and index < members.size():
		members[index]["name"] = new_name
		members[index]["color_hex"] = new_color.to_html()
		save_data()

func remove_member(index: int):
	if index >= 0 and index < members.size():
		members.remove_at(index)
		save_data()

func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_str = JSON.stringify(members)
		file.store_string(json_str)
		file.close()
		print("System data saved.")

func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		return # no save
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_str = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_str)
	
	if error == OK:
		var data = json.data
		if typeof(data) == TYPE_ARRAY:
			members = data
			print("System data loaded: ", members.size(), " members.")
	else:
		print("JSON Parse Error")
