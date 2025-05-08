extends Node2D

var max_hp = 100
var hp = 100
var is_charging = false

func is_dead():
	return hp <= 0

func attack(target, base_dmg: int, crit_mult: float):
	var dmg = base_dmg
	$MinoAnim.play("Hit")
	target.receive_damage(int(dmg))
	$"../UI".show_battle_message(name + " dealt " + str(int(dmg)) + " to " + target.name)

func receive_damage(dmg):
	hp = max(0, hp - dmg)
	update_ui()

func special_move(target):
	var dmg = randi_range(15, 30)
	target.receive_damage(dmg)

func heal(amount):
	hp = min(max_hp, hp + amount)
	update_ui()
	$UI.show_battle_message(name + " recovered " + str(amount) + " HP")

func update_ui():
	$hplabel3.text = "HP: " + str(hp)
