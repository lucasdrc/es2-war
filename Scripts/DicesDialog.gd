extends WindowDialog

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
