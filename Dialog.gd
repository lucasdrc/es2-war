extends RichTextLabel

var dialog_text = ""
func _ready():
	set_bbcode(dialog_text)

func _on_Button_pressed():
	var root = get_tree().get_root()
	var level = get_tree().get_current_scene()
	root.remove_child(level)
	level.call_deferred("free")
