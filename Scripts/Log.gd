extends Node

onready var log_msgs = "TEXTO DO LOG"
func add_log_msg(msg):
	var datetime = OS.get_datetime()
	var log_msg = "[{0}/{1}/{2} {3}:{4}:{5}] {6}".format([
						datetime["day"],
						datetime["month"],
						datetime["year"],
						datetime["hour"],
						datetime["minute"],
						datetime["second"],
						msg
						])
	log_msgs += "\n\n" + log_msg
