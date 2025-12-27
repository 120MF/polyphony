extends Node

var overlay: ColorRect
var canvas: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas = CanvasLayer.new()
	canvas.layer = 100
	add_child(canvas)
	
	overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.modulate.a = 0.0 # transparent
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(overlay)

func change_scene(path: String):
	# stop click
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# black fade in
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 0.3)
	await tween.finished
	
	# switch scene
	get_tree().change_scene_to_file(path)
	
	# black fadeout
	tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 0.0, 0.3)
	await tween.finished
	
	# 5. 恢复点击
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
