extends Node2D

var max_hp = 100
var hp = 100
var is_charging = false


func is_dead():
	return hp <= 0

func attack(target, base_dmg: int, crit_mult: float):
	var dmg = base_dmg
	$AnimationPlayer2.play("Hit")
	target.receive_damage(int(dmg))
	$"../UI".show_battle_message(name + " dealt " + str(int(dmg)) + " to " + target.name)

func receive_damage(dmg):
	hp = max(0, hp - dmg)
	update_ui()

func heal(amount):
	hp = min(max_hp, hp + amount)
	$AnimationPlayer2.play("Heal")
	update_ui()
	$"../UI".show_battle_message(name + " recovered " + str(amount) + " HP")

func update_ui():
	$hplabel2.text = "HP: " + str(hp)
	pass
