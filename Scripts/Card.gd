extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var territory_text = ""
var shape_text = ""
var selected = false
var image = "res://Resources/rectangle.png"
var plus_two_infantry = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# $Panel/ColorRect/Shape.text = shape_text
	$Panel/ColorRect/Territory.text = territory_text
	$Panel/ColorRect/Shape.texture = load(image)
	$Panel/ColorRect/PlusTwoInfantry.visible = plus_two_infantry
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_CheckBox_pressed():
	selected = !selected
