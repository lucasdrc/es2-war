extends WindowDialog

var rng = RandomNumberGenerator.new()
var totalAttack = 0
var totalDefense = 0

func _ready():
	pass # Replace with function body.

func showAttack(attack):
	for n in attack.size():
		if n == 0:
			$GridContainer/Attack/GridContainer/Dice1.show()
			$GridContainer/Attack/GridContainer/Dice1.showDice(attack[n])
		elif n == 1:
			$GridContainer/Attack/GridContainer/Dice2.show()
			$GridContainer/Attack/GridContainer/Dice2.showDice(attack[n])
		elif n == 2:
			$GridContainer/Attack/GridContainer/Dice3.show()
			$GridContainer/Attack/GridContainer/Dice3.showDice(attack[n])
		elif n == 3:
			$GridContainer/Attack/GridContainer/Dice4.show()
			$GridContainer/Attack/GridContainer/Dice4.showDice(attack[n])
		elif n == 4:
			$GridContainer/Attack/GridContainer/Dice5.show()
			$GridContainer/Attack/GridContainer/Dice5.showDice(attack[n])
		else:
			$GridContainer/Attack/GridContainer/Dice6.show()
			$GridContainer/Attack/GridContainer/Dic6.showDice(attack[n])
	for value in attack:
		totalAttack += value
	$GridContainer/Attack/VBoxContainer/Result.text = str(totalAttack)

func showDefense(defense):
	for n in defense.size():
		if n == 0:
			$GridContainer/Defense/GridContainer/Dice1.show()
			$GridContainer/Defense/GridContainer/Dice1.showDice(defense[n])
		elif n == 1:
			$GridContainer/Defense/GridContainer/Dice2.show()
			$GridContainer/Defense/GridContainer/Dice2.showDice(defense[n])
		elif n == 2:
			$GridContainer/Defense/GridContainer/Dice3.show()
			$GridContainer/Defense/GridContainer/Dice3.showDice(defense[n])
		elif n == 3:
			$GridContainer/Defense/GridContainer/Dice4.show()
			$GridContainer/Defense/GridContainer/Dice4.showDice(defense[n])
		elif n == 4:
			$GridContainer/Defense/GridContainer/Dice5.show()
			$GridContainer/Defense/GridContainer/Dice5.showDice(defense[n])
		else:
			$GridContainer/Defense/GridContainer/Dice6.show()
			$GridContainer/Defense/GridContainer/Dic6.showDice(defense[n])
	for value in defense:
		totalDefense += value
	$GridContainer/Defense/VBoxContainer/Result.text = str(totalDefense)

func calculateDefense(num_troops):
	var dice_results = []
	for n in num_troops:
		dice_results.append(rng.randi_range(1.0, 6.0))
	print(dice_results)
	showDefense(dice_results)


func _on_ConfirmButton_pressed():
	$".".hide()
