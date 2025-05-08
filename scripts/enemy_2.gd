extends Node2D

var max_hp = 100
var hp = 100
var is_charging = false

func is_dead():
	return hp <= 0

func attack(target, base_dmg: int, crit_mult: float):
	var dmg = base_dmg
	$NightAnim.play("Hit")
	target.receive_damage(int(dmg))
	$"../UI".show_battle_message(name + " dealt " + str(int(dmg)) + " to " + target.name)

func receive_damage(dmg):
	hp = max(0, hp - dmg)
	update_ui()

func defend():
	$"../UI".show_battle_message(name + " is defending")
	# reduce damage next turn (not implemented in detail here)

func charge():
	is_charging = true
	$"../UI".show_battle_message(name + " is charging a powerful attack!")

func use_item(item):
	if item == "potion":
		hp = min(max_hp, hp + 30)
		update_ui()
		$"../UI".show_battle_message(name + " used a potion")

func special_move(target):
	var dmg = randi_range(15, 30)
	target.receive_damage(dmg)
	
func heal(amount):
	hp = min(max_hp, hp + amount)
	update_ui()
	$UI.show_battle_message(name + " recovered " + str(amount) + " HP")

func update_ui():
	$hplabel4.text = "HP: " + str(hp)
