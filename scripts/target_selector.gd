extends Control

var target_callback = null

func set_target_callback(callback_func):
	target_callback = callback_func

func show_targets(targets):
	for child in $ButtonsContainer.get_children():
		child.queue_free()

	for target in targets:
		var btn = Button.new()
		btn.text = target.name
		btn.add_theme_font_size_override("font_size", 8)
		btn.pressed.connect(func(): _on_target_selected(target))
		$ButtonsContainer.add_child(btn)

	show()

func _on_target_selected(target):
	if target_callback != null:
		target_callback.call(target)
		target_callback = null
	hide()
