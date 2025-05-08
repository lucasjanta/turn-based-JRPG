extends Node2D

# Holds player and enemy characters
var players = []
var enemies = []
var turn_queue = []
var current_actor = null
var is_player_turn = true
var battle_log = []

func _ready():
	players = [$Player1, $Player2]
	enemies = [$Minotaur, $Nightborne]
	turn_queue = players + enemies
	$UI.player_action_selected.connect(on_player_action)
	start_next_turn()

func start_next_turn():
	if is_battle_over():
		return
	
	current_actor = turn_queue.pop_front()
	turn_queue.append(current_actor)
	print(current_actor)
	
	if current_actor in players:
		is_player_turn = true
		$UI.show_player_options(current_actor)
	else:
		is_player_turn = false
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
	match action:
		"Attack1":
			current_actor.attack(target, 10, 0.2)
		"Attack2":
			current_actor.attack(target, 20, 0.5)
		"Defend":
			current_actor.defend()
		"Charge":
			current_actor.charge()
		"Item":
			current_actor.use_item("potion")
	
	start_next_turn()

func perform_enemy_action(enemy):
	var targets = players.filter(func(p): return not p.is_dead())
	if targets.size() == 0:
		return

	var target = targets[randi() % targets.size()]
	var move = randi() % 2

	if move == 0:
		enemy.attack(target, 8, 0.2)
		$UI.show_battle_message(enemy.name + " attacks " + target.name)
	else:
		enemy.special_move(target)
		$UI.show_battle_message(enemy.name + " used special move on " + target.name)
	
	await get_tree().create_timer(1.0).timeout
	start_next_turn()
