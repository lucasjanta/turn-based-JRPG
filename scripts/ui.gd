extends Control

signal player_action_selected(action, target)

func _ready():
	$ActionMenu/Attack1.pressed.connect(func(): _on_action_pressed("Attack1"))
	$ActionMenu/Attack2.pressed.connect(func(): _on_action_pressed("Attack2"))
	$ActionMenu/Heal.pressed.connect(func(): _on_action_pressed("Heal"))

func show_player_options(player):
	$ActionMenu.visible = true
	for child in $ActionMenu.get_children():
		child.visible = false

	if player.name == "Percy":
		$"../Sprite2D".visible = true
		$"../Sprite2D".global_position.x = 106.0
		$ActionMenu/Attack1.text = "Slash (10-20)"
		$ActionMenu/Attack2.text = "Lunge (5-40)"
		$ActionMenu/Heal.text = "Heal (30)"
		$ActionMenu/Attack1.visible = true
		$ActionMenu/Attack2.visible = true
		$ActionMenu/Heal.visible = true
	elif player.name == "Annabeth":
		$"../Sprite2D".visible = true
		$"../Sprite2D".global_position.x = 43.0
		$ActionMenu/Attack1.text = "Strike (15)"
		$ActionMenu/Attack2.text = "Area Slash (15 All)"
		$ActionMenu/Heal.text = "Group Heal (15)"
		$ActionMenu/Attack1.visible = true
		$ActionMenu/Attack2.visible = true
		$ActionMenu/Heal.visible = true

func _on_action_pressed(action):
	$ActionMenu.visible = false
	if action in ["Heal", "GroupHeal"]:
		emit_signal("player_action_selected", action, null)
		return

	var targets = get_tree().get_nodes_in_group("enemies")
	targets = targets.filter(func(e): return not e.is_dead())
	$TargetSelector.set_target_callback(func(target):
		emit_signal("player_action_selected", action, target)
		$TargetSelector.hide()
	)
	$TargetSelector.show_targets(targets)

func show_battle_message(text):
	$BattleLog.text += text + "\n"
