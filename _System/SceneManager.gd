extends Node

var scene_container: Node
var transition_rect: ColorRect

func _ready():
	# 这一步是为了防止单独运行子场景时报错（方便调试）
	# 但最终游戏应该总是从 Main 运行
	var root = get_tree().root.get_node_or_null("Main")
	if root:
		scene_container = root.get_node("SceneContainer")
		transition_rect = root.get_node("TRLayer/ColorRect")
		
		# 初始状态：确保遮罩是透明的，且不挡鼠标
		transition_rect.modulate.a = 0.0
		transition_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		# 启动时加载第一个场景 (Splash)
		change_scene("res://Scenes/Splash.tscn", false)

func change_scene(scene_path: String, use_transition: bool = true):
	if not scene_container:
		print_debug("Error: SceneContainer not found. Run from Main.tscn!")
		# 降级处理：如果单独运行，还是用旧方法
		get_tree().change_scene_to_file(scene_path)
		return

	# 1. 淡入黑色 (遮住屏幕)
	if use_transition:
		transition_rect.mouse_filter = Control.MOUSE_FILTER_STOP
		var tween = create_tween()
		tween.tween_property(transition_rect, "modulate:a", 1.0, 0.3)
		await tween.finished
	
	# 2. 销毁旧场景
	for child in scene_container.get_children():
		child.queue_free()
	
	# 3. 实例化并添加新场景
	var new_scene_res = load(scene_path)
	var new_scene_instance = new_scene_res.instantiate()
	scene_container.add_child(new_scene_instance)
	
	# 4. 淡出黑色 (显示新场景)
	if use_transition:
		var tween = create_tween()
		tween.tween_property(transition_rect, "modulate:a", 0.0, 0.3)
		await tween.finished
		transition_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
