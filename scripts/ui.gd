extends Control

signal player_action_selected(action, target)

func show_player_options(player):
	$ActionMenu.visible = true
	$ActionMenu/Attack1.pressed.connect(func(): _on_action_pressed("Attack1"))
	$ActionMenu/Attack2.pressed.connect(func(): _on_action_pressed("Attack2"))
	$ActionMenu/Defend.pressed.connect(func(): _on_action_pressed("Defend"))
	$ActionMenu/Charge.pressed.connect(func(): _on_action_pressed("Charge"))
	$ActionMenu/Item.pressed.connect(func(): _on_action_pressed("Item"))

func _on_action_pressed(action):
	$ActionMenu.visible = false
	var targets = get_tree().get_nodes_in_group("enemies")  # ou sua lógica de alvos válidos
	$TargetSelector.set_target_callback(func(target):
		emit_signal("player_action_selected", action, target)
		$TargetSelector.hide()
	)
	$TargetSelector.show_targets(targets)
	$TargetSelector.set_target_callback(func(target):
		emit_signal("player_action_selected", action, target)
		print(action, target)
		$TargetSelector.hide()
	)

func show_battle_message(text):
	$BattleLog.text += text + "\n"
