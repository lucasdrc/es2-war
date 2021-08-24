extends RichTextLabel

var dialog_text = ""
func _ready():
	set_bbcode(dialog_text)

func _on_Button_pressed():
	get_parent().queue_free()
