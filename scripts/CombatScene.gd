extends Node2D

# Holds player and enemy characters
var players = []
var enemies = []
var turn_queue = []
var current_actor = null
var is_player_turn = true
var battle_log = []

func _ready():
	players = [$Percy, $Annabeth]
	enemies = [$Minotaur, $Nightborne]
	turn_queue = players + enemies
	$UI.player_action_selected.connect(on_player_action)
	start_next_turn()

func start_next_turn():
	if is_battle_over():
		return
		
	# Remove mortos da fila
	turn_queue = turn_queue.filter(func(actor): return not actor.is_dead())

	if turn_queue.size() == 0:
		return
	
	current_actor = turn_queue.pop_front()
	turn_queue.append(current_actor)
	
	if current_actor in players:
		is_player_turn = true
		$UI.show_player_options(current_actor)
	else:
		is_player_turn = false
		$Sprite2D.visible = false
		await get_tree().create_timer(1.0).timeout
		perform_enemy_action(current_actor)

func is_battle_over():
	var all_players_dead = players.all(func(p): return p.is_dead())
	var all_enemies_dead = enemies.all(func(e): return e.is_dead())

	if all_players_dead:
		$UI.show_battle_message("All players defeated. You lose!")
		return true
	elif all_enemies_dead:
		$UI.show_battle_message("All enemies defeated. You win!")
		return true
	return false

func on_player_action(action: String, target):
	if current_actor.name == "Percy":
		match action:
			"Attack1":
				current_actor.attack(target, randi_range(10, 20), 0.2)
			"Attack2":
				current_actor.attack(target, randi_range(5, 40), 0.5)
			"Heal":
				current_actor.heal(30)
	elif current_actor.name == "Annabeth":
		match action:
			"Attack1":
				current_actor.attack(target, 15, 0.1)
			"Attack2":
				for enemy in enemies:
					if not enemy.is_dead():
						current_actor.attack(enemy, 15, 0.1)
			"Heal":
				for player in players:
					if not player.is_dead():
						player.heal(15)
	
	start_next_turn()

func perform_enemy_action(enemy):
	var targets = players.filter(func(p): return not p.is_dead())
	if targets.size() == 0:
		return

	var move = randi() % 2

	if enemy.name == "Minotaur":
		if move == 0:
			var target = targets[randi() % targets.size()]
			$UI.show_battle_message(enemy.name + " attacks " + target.name)
			enemy.attack(target, randi_range(10, 15), 0.1)
		else:
			$UI.show_battle_message(enemy.name + "used Bull Rush on all players")
			for player in players:
				if not player.is_dead():
					enemy.attack(player, 20, 0.1)
	elif enemy.name == "Nightborne":
		if move == 0:
			var target = targets[randi() % targets.size()]
			$UI.show_battle_message(enemy.name + " attacks " + target.name)
			enemy.attack(target, randi_range(15, 20), 0.1)
		else:
			var target = targets[randi() % targets.size()]
			$UI.show_battle_message(enemy.name + " used Nightmare Slash on " + target.name)
			enemy.attack(target, 30, 0.1)

	await get_tree().create_timer(1.0).timeout
	start_next_turn()
