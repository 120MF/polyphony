extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_orientation()
	
	get_tree().root.size_changed.connect(check_orientation)

func check_orientation():
	var screen_size = get_viewport_rect().size
	if screen_size.x < screen_size.y:
		show()
	else:
		hide()
