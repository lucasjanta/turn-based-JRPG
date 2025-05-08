extends Node2D

var max_hp = 100
var hp = 100
var is_charging = false

const CRITICAL_CHANCE = 0.1
const DAMAGE_VARIATION = 0.2

func is_dead():
	return hp <= 0

func attack(target, base_dmg: int, crit_mult: float):
	var dmg = base_dmg + randf_range(-base_dmg * DAMAGE_VARIATION, base_dmg * DAMAGE_VARIATION)
	var is_crit = randf() < CRITICAL_CHANCE
	if is_crit:
		dmg *= (1 + crit_mult)
	if is_charging:
		dmg *= 2
		is_charging = false
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

func update_ui():
	$hplabel2.text = "HP: " + str(hp)
	pass
