extends Polygon2D

func _ready(): $TextLabel.text = Log.log_msgs
func _on_Button_pressed(): queue_free()
