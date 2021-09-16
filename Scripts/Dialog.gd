extends Polygon2D

onready var dialog_text_label = get_node("DialogTextLabel")
var dialog_text = ""
var time = 0

func _ready():
	dialog_text_label.set_bbcode(dialog_text)

func _process(delta): time += delta

func _on_Button_pressed():
	queue_free()
